import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/purchase_invoices_table.dart';
import '../tables/purchase_items_table.dart';
import '../tables/ingredients_table.dart';
import '../tables/treasury_transactions_table.dart';
import '../tables/shifts_table.dart';

part 'purchase_dao.g.dart';

@DriftAccessor(tables: [PurchaseInvoices, PurchaseItems, Ingredients, TreasuryTransactions, Shifts])
class PurchaseDao extends DatabaseAccessor<AppDatabase> with _$PurchaseDaoMixin {
  PurchaseDao(super.db);

  /// Create a purchase invoice atomically:
  /// 1. Insert PurchaseInvoice header
  /// 2. For each item:
  ///    a. Insert PurchaseItem
  ///    b. Recalculate WAC cost price for Ingredient
  ///    c. Update Ingredient stock and cost price
  /// 3. Insert TreasuryTransaction co-transactionally
  /// 4. Update active Shift's totalPurchases
  Future<int> createPurchaseInvoice({
    required int userId,
    required int? shiftId,
    required String? supplierName,
    required String? notes,
    required List<PurchaseItemInput> items,
  }) {
    return transaction(() async {
      // 1. Calculate total amount and generate invoice number
      double totalAmount = 0.0;
      for (final item in items) {
        totalAmount += item.quantity * item.unitCost;
      }

      final dateStr = DateTime.now().toIso8601String().substring(0, 10).replaceAll('-', '');
      final count = await (select(purchaseInvoices)).get();
      final sequence = count.length + 1;
      final invoiceNumber = 'PUR-$dateStr-${sequence.toString().padLeft(4, '0')}';

      // 2. Insert Invoice Header
      final invoiceId = await into(purchaseInvoices).insert(
        PurchaseInvoicesCompanion.insert(
          invoiceNumber: invoiceNumber,
          supplierName: Value(supplierName),
          userId: userId,
          shiftId: Value(shiftId),
          totalAmount: totalAmount,
          notes: Value(notes),
          status: const Value('completed'),
        ),
      );

      // 3. Process items and update inventory
      for (final item in items) {
        final lineTotal = item.quantity * item.unitCost;
        await into(purchaseItems).insert(
          PurchaseItemsCompanion.insert(
            purchaseInvoiceId: invoiceId,
            ingredientId: item.ingredientId,
            quantity: item.quantity,
            unitCost: item.unitCost,
            lineTotal: lineTotal,
          ),
        );

        // Update Ingredient stock and recalculate Cost Price (WAC)
        final ingredient = await (select(ingredients)
              ..where((i) => i.id.equals(item.ingredientId)))
            .getSingle();

        double newCostPrice = item.unitCost;
        if (ingredient.currentStock > 0) {
          final totalVal = (ingredient.currentStock * ingredient.costPrice) + (item.quantity * item.unitCost);
          final totalQty = ingredient.currentStock + item.quantity;
          newCostPrice = totalQty > 0 ? (totalVal / totalQty) : item.unitCost;
        }

        await (update(ingredients)..where((i) => i.id.equals(item.ingredientId))).write(
          IngredientsCompanion(
            currentStock: Value(ingredient.currentStock + item.quantity),
            costPrice: Value(newCostPrice),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }

      // 4. Create Treasury Transaction
      final latest = await (select(treasuryTransactions)
            ..orderBy([(t) => OrderingTerm.desc(t.id)])
            ..limit(1))
          .getSingleOrNull();
      final prevBalance = latest?.balanceAfter ?? 0.0;
      final newBalance = prevBalance - totalAmount;

      await into(treasuryTransactions).insert(
        TreasuryTransactionsCompanion.insert(
          shiftId: Value(shiftId),
          userId: userId,
          type: 'purchase_expense',
          amount: totalAmount,
          referenceType: const Value('purchase_invoice'),
          referenceId: Value(invoiceId),
          description: Value('Purchase Expense for Invoice #$invoiceNumber'),
          balanceAfter: newBalance,
        ),
      );

      // 5. Update active shift's totalPurchases
      if (shiftId != null) {
        final activeShift = await (select(shifts)..where((s) => s.id.equals(shiftId))).getSingle();
        if (activeShift.status != 'open') {
          throw Exception('Shift is not open');
        }
        await (update(shifts)..where((s) => s.id.equals(shiftId))).write(
          ShiftsCompanion(
            totalPurchases: Value(activeShift.totalPurchases + totalAmount),
          ),
        );
      }

      return invoiceId;
    });
  }

  /// Get all purchase invoices.
  Future<List<PurchaseInvoice>> getAllInvoices() {
    return (select(purchaseInvoices)
          ..orderBy([(pi) => OrderingTerm.desc(pi.createdAt)]))
        .get();
  }

  /// Get line items for a purchase invoice.
  Future<List<PurchaseItem>> getItemsForInvoice(int invoiceId) {
    return (select(purchaseItems)
          ..where((pi) => pi.purchaseInvoiceId.equals(invoiceId)))
        .get();
  }

  /// Void purchase invoice (reverses inventory and treasury).
  Future<bool> voidPurchaseInvoice(int invoiceId) {
    return transaction(() async {
      final invoice = await (select(purchaseInvoices)..where((pi) => pi.id.equals(invoiceId))).getSingle();
      if (invoice.status == 'voided') {
        throw Exception('Invoice is already voided');
      }

      // 1. Mark as voided
      await (update(purchaseInvoices)..where((pi) => pi.id.equals(invoiceId))).write(
        PurchaseInvoicesCompanion(
          status: const Value('voided'),
          updatedAt: Value(DateTime.now()),
        ),
      );

      // 2. Fetch items to reverse stock
      final items = await getItemsForInvoice(invoiceId);
      for (final item in items) {
        final ingredient = await (select(ingredients)
              ..where((i) => i.id.equals(item.ingredientId)))
            .getSingle();

        final newStock = ingredient.currentStock - item.quantity;
        await (update(ingredients)..where((i) => i.id.equals(item.ingredientId))).write(
          IngredientsCompanion(
            currentStock: Value(newStock < 0 ? 0.0 : newStock),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }

      // 3. Create Refund Treasury Transaction
      final latest = await (select(treasuryTransactions)
            ..orderBy([(t) => OrderingTerm.desc(t.id)])
            ..limit(1))
          .getSingleOrNull();
      final prevBalance = latest?.balanceAfter ?? 0.0;
      final newBalance = prevBalance + invoice.totalAmount;

      await into(treasuryTransactions).insert(
        TreasuryTransactionsCompanion.insert(
          shiftId: Value(invoice.shiftId),
          userId: invoice.userId,
          type: 'sale_income', // Add money back to cash flow
          amount: invoice.totalAmount,
          referenceType: const Value('purchase_invoice'),
          referenceId: Value(invoiceId),
          description: Value('Void Purchase Refund for Invoice #${invoice.invoiceNumber}'),
          balanceAfter: newBalance,
        ),
      );

      // 4. Update Shift (subtract from totalPurchases)
      if (invoice.shiftId != null) {
        final activeShift = await (select(shifts)..where((s) => s.id.equals(invoice.shiftId!))).getSingle();
        await (update(shifts)..where((s) => s.id.equals(invoice.shiftId!))).write(
          ShiftsCompanion(
            totalPurchases: Value(activeShift.totalPurchases - invoice.totalAmount),
          ),
        );
      }

      return true;
    });
  }
}

/// Input DTO for purchase item creation.
class PurchaseItemInput {
  final int ingredientId;
  final double quantity;
  final double unitCost;

  PurchaseItemInput({
    required this.ingredientId,
    required this.quantity,
    required this.unitCost,
  }) {
    assert(quantity > 0, 'Quantity must be greater than zero.');
    assert(unitCost >= 0, 'Unit cost cannot be negative.');
  }
}
