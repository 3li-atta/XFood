import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/transactions_table.dart';
import '../tables/transaction_items_table.dart';
import '../tables/recipes_table.dart';
import '../tables/ingredients_table.dart';
import '../tables/meals_table.dart';
import '../tables/shifts_table.dart';
import '../tables/treasury_transactions_table.dart';
import '../../core/error/exceptions.dart';

part 'transaction_dao.g.dart';

/// Data Access Object for transaction operations.
///
/// Contains the critical [createSaleWithStockDeduction] method that
/// atomically records a sale AND deducts ingredient stock via recipes.
@DriftAccessor(
    tables: [Transactions, TransactionItems, Recipes, Ingredients, Meals, Shifts, TreasuryTransactions])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(super.db);

  // ── Queries ─────────────────────────────────────────────────

  /// Get all transactions, newest first.
  Future<List<Transaction>> getAllTransactions() {
    return (select(transactions)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Get transactions filtered by type.
  Future<List<Transaction>> getTransactionsByType(String type) {
    return (select(transactions)
          ..where((t) => t.type.equals(type))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Get transactions for a specific date range.
  Future<List<Transaction>> getTransactionsByDateRange(
      DateTime start, DateTime end) {
    return (select(transactions)
          ..where((t) =>
              t.createdAt.isBiggerOrEqualValue(start) &
              t.createdAt.isSmallerOrEqualValue(end))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Get all line items for a specific transaction.
  Future<List<TransactionItem>> getItemsForTransaction(int transactionId) {
    return (select(transactionItems)
          ..where((ti) => ti.transactionId.equals(transactionId)))
        .get();
  }

  /// Watch transactions (reactive stream for dashboard).
  Stream<List<Transaction>> watchAllTransactions() {
    return (select(transactions)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  // ── Sale with Automated Stock Deduction ─────────────────────

  /// ★ CORE BUSINESS LOGIC: Create a sale and automatically deduct stock.
  ///
  /// Runs inside a DB transaction to ensure atomicity:
  /// 1. Validate the active shift is open
  /// 2. Server-calculate the totalAmount from line items
  /// 3. Insert the Transaction header
  /// 4. For each line item (meal sold):
  ///    a. Insert the TransactionItem
  ///    b. Query Recipes for all ingredients of that meal
  ///    c. Atomically deduct (quantity_required × quantity_sold) from each ingredient
  ///    d. Throw InsufficientStockException & ROLLBACK if stock is insufficient
  /// 5. Record TreasuryTransaction for the sale income co-transactionally
  /// 6. Update Shift totalSales co-transactionally
  Future<int> createSaleWithStockDeduction({
    required int userId,
    required int? shiftId,
    required String? notes,
    required List<SaleLineItem> lineItems,
    double discountPercentage = 0.0,
  }) {
    return transaction(() async {
      // 1. Shift validation
      if (shiftId == null) {
        throw Exception('A cashier must have an active open shift to make sales.');
      }
      final activeShift = await (select(shifts)..where((s) => s.id.equals(shiftId))).getSingleOrNull();
      if (activeShift == null || activeShift.status != 'open') {
        throw Exception('The associated shift is not active or is closed.');
      }

      // 2. Server-calculate totalAmount to prevent client price manipulation (V-03)
      double calculatedTotal = 0.0;
      for (final item in lineItems) {
        calculatedTotal += item.quantity * item.priceAtTime;
      }
      if (discountPercentage > 0) {
        calculatedTotal = calculatedTotal * (1 - discountPercentage / 100);
      }

      // 3. Insert transaction header
      final txnId = await into(transactions).insert(
        TransactionsCompanion.insert(
          userId: userId,
          shiftId: Value(shiftId),
          type: 'sale',
          totalAmount: calculatedTotal,
          notes: Value(discountPercentage > 0
              ? '[Discount: ${discountPercentage.toStringAsFixed(0)}%]${notes != null ? " $notes" : ""}'
              : notes),
        ),
      );

      // 4. Process each line item
      for (final item in lineItems) {
        // Insert line item record
        await into(transactionItems).insert(
          TransactionItemsCompanion.insert(
            transactionId: txnId,
            mealId: Value(item.mealId),
            quantity: item.quantity,
            priceAtTime: item.priceAtTime,
            itemType: 'meal',
          ),
        );

        // Fetch recipe rows for this meal
        final recipeRows = await (select(recipes)
              ..where((r) => r.mealId.equals(item.mealId)))
            .get();

        // Deduct each ingredient's stock
        for (final recipe in recipeRows) {
          final deduction = recipe.quantityRequired * item.quantity;

          // Read current stock for exception details if update fails
          final ingredient = await (select(ingredients)
                ..where((i) => i.id.equals(recipe.ingredientId)))
              .getSingle();

          // Atomically update stock level (V-01: Fix TOCTOU race condition)
          final updatedRows = await customUpdate(
            'UPDATE ingredients SET current_stock = current_stock - ?, updated_at = ? WHERE id = ? AND current_stock >= ?',
            variables: [
              Variable<double>(deduction),
              Variable<DateTime>(DateTime.now()),
              Variable<int>(recipe.ingredientId),
              Variable<double>(deduction),
            ],
            updates: {ingredients},
          );

          // Validate stock sufficiency
          if (updatedRows == 0) {
            throw InsufficientStockException(
              ingredientName: ingredient.name,
              required: deduction,
              available: ingredient.currentStock,
            );
          }
        }
      }

      // 5. Create Treasury Transaction (co-transactional)
      final latest = await (select(treasuryTransactions)
            ..orderBy([(t) => OrderingTerm.desc(t.id)])
            ..limit(1))
          .getSingleOrNull();
      final prevBalance = latest?.balanceAfter ?? 0.0;
      final newBalance = prevBalance + calculatedTotal;

      await into(treasuryTransactions).insert(
        TreasuryTransactionsCompanion.insert(
          shiftId: Value(shiftId),
          userId: userId,
          type: 'sale_income',
          amount: calculatedTotal,
          referenceType: const Value('transaction'),
          referenceId: Value(txnId),
          description: Value('Sale income from Transaction #$txnId'),
          balanceAfter: newBalance,
        ),
      );

      // 6. Update Shift totalSales (co-transactional)
      await (update(shifts)..where((s) => s.id.equals(shiftId))).write(
        ShiftsCompanion(
          totalSales: Value(activeShift.totalSales + calculatedTotal),
        ),
      );

      return txnId;
    });
  }

  // ── Waste Recording ─────────────────────────────────────────

  /// Record waste and deduct ingredient stock.
  /// Throws InsufficientStockException if not enough stock (V-04).
  Future<int> recordWaste({
    required int userId,
    required String? notes,
    required List<WasteLineItem> lineItems,
  }) {
    return transaction(() async {
      double totalLoss = 0;

      final txnId = await into(transactions).insert(
        TransactionsCompanion.insert(
          userId: userId,
          type: 'waste',
          totalAmount: 0, // Will update after calculating
          notes: Value(notes),
        ),
      );

      for (final item in lineItems) {
        final ingredient = await (select(ingredients)
              ..where((i) => i.id.equals(item.ingredientId)))
            .getSingle();

        final loss = item.quantity * ingredient.costPrice;
        totalLoss += loss;

        await into(transactionItems).insert(
          TransactionItemsCompanion.insert(
            transactionId: txnId,
            ingredientId: Value(item.ingredientId),
            quantity: item.quantity,
            priceAtTime: ingredient.costPrice,
            itemType: 'ingredient',
          ),
        );

        // Atomically update stock level (V-01 & V-04)
        final updatedRows = await customUpdate(
          'UPDATE ingredients SET current_stock = current_stock - ?, updated_at = ? WHERE id = ? AND current_stock >= ?',
          variables: [
            Variable<double>(item.quantity),
            Variable<DateTime>(DateTime.now()),
            Variable<int>(item.ingredientId),
            Variable<double>(item.quantity),
          ],
          updates: {ingredients},
        );

        if (updatedRows == 0) {
          throw InsufficientStockException(
            ingredientName: ingredient.name,
            required: item.quantity,
            available: ingredient.currentStock,
          );
        }
      }

      // Update total loss amount
      await (update(transactions)..where((t) => t.id.equals(txnId)))
          .write(TransactionsCompanion(totalAmount: Value(totalLoss)));

      return txnId;
    });
  }

  /// Calculate Cost of Goods Sold (COGS) for sales in a date range using joins.
  Future<double> getCOGSForDateRange(DateTime start, DateTime end) async {
    // 1. Calculate sales COGS
    final saleQuery = select(transactionItems).join([
      innerJoin(transactions, transactions.id.equalsExp(transactionItems.transactionId)),
      innerJoin(recipes, recipes.mealId.equalsExp(transactionItems.mealId)),
      innerJoin(ingredients, ingredients.id.equalsExp(recipes.ingredientId)),
    ])
      ..where(transactions.type.equals('sale') &
          transactions.createdAt.isBiggerOrEqualValue(start) &
          transactions.createdAt.isSmallerOrEqualValue(end));

    final saleRows = await saleQuery.get();
    double saleCOGS = 0.0;
    for (final row in saleRows) {
      final itemQty = row.readTable(transactionItems).quantity;
      final recipeQty = row.readTable(recipes).quantityRequired;
      final cost = row.readTable(ingredients).costPrice;
      saleCOGS += itemQty * recipeQty * cost;
    }

    // 2. Calculate refund COGS
    final refundQuery = select(transactionItems).join([
      innerJoin(transactions, transactions.id.equalsExp(transactionItems.transactionId)),
      innerJoin(recipes, recipes.mealId.equalsExp(transactionItems.mealId)),
      innerJoin(ingredients, ingredients.id.equalsExp(recipes.ingredientId)),
    ])
      ..where(transactions.type.equals('refund') &
          transactions.createdAt.isBiggerOrEqualValue(start) &
          transactions.createdAt.isSmallerOrEqualValue(end));

    final refundRows = await refundQuery.get();
    double refundCOGS = 0.0;
    for (final row in refundRows) {
      final itemQty = row.readTable(transactionItems).quantity;
      final recipeQty = row.readTable(recipes).quantityRequired;
      final cost = row.readTable(ingredients).costPrice;
      refundCOGS += itemQty * recipeQty * cost;
    }

    return saleCOGS - refundCOGS;
  }

  /// Check if a sale transaction has already been refunded.
  Future<bool> isTransactionRefunded(int transactionId) async {
    final query = select(transactions)
      ..where((t) => t.type.equals('refund') & t.notes.like('%Refund for Transaction #$transactionId%'));
    final list = await query.get();
    return list.isNotEmpty;
  }

  /// Refund a sale transaction, restoring stock, adding treasury cash_out, and updating shift sales.
  Future<bool> refundSaleTransaction({
    required int transactionId,
    required int userId,
  }) {
    return transaction(() async {
      // 1. Get currently active open shift
      final activeShift = await (select(shifts)..where((s) => s.status.equals('open'))).getSingleOrNull();
      if (activeShift == null) {
        throw Exception('لا يمكن إرجاع طلب بدون وجود وردية مفتوحة نشطة.');
      }

      // 2. Fetch original transaction
      final origTxn = await (select(transactions)..where((t) => t.id.equals(transactionId))).getSingleOrNull();
      if (origTxn == null) {
        throw Exception('الطلب الأصلي غير موجود.');
      }
      if (origTxn.type != 'sale') {
        throw Exception('يمكن فقط عمل مرتجع لطلبات المبيعات.');
      }

      // 3. Check if already refunded
      final alreadyRefunded = await isTransactionRefunded(transactionId);
      if (alreadyRefunded) {
        throw Exception('هذا الطلب تم إرجاعه بالفعل.');
      }

      final refundAmount = origTxn.totalAmount;

      // 4. Create refund transaction header
      final refundTxnId = await into(transactions).insert(
        TransactionsCompanion.insert(
          userId: userId,
          shiftId: Value(activeShift.id),
          type: 'refund',
          totalAmount: refundAmount,
          notes: Value('Refund for Transaction #$transactionId'),
        ),
      );

      // 5. Fetch items from original transaction
      final origItems = await getItemsForTransaction(transactionId);
      for (final item in origItems) {
        // Insert line item record for refund
        await into(transactionItems).insert(
          TransactionItemsCompanion.insert(
            transactionId: refundTxnId,
            mealId: Value(item.mealId),
            quantity: item.quantity,
            priceAtTime: item.priceAtTime,
            itemType: 'meal',
          ),
        );

        // Reverse stock (add back ingredients)
        if (item.mealId != null) {
          final recipeRows = await (select(recipes)
                ..where((r) => r.mealId.equals(item.mealId!)))
              .get();

          for (final recipe in recipeRows) {
            final incrementAmount = recipe.quantityRequired * item.quantity;
            final ing = await (select(ingredients)
                  ..where((i) => i.id.equals(recipe.ingredientId)))
                .getSingle();
            final updatedStock = ing.currentStock + incrementAmount;

            await (update(ingredients)..where((i) => i.id.equals(recipe.ingredientId))).write(
              IngredientsCompanion(
                currentStock: Value(updatedStock),
                updatedAt: Value(DateTime.now()),
              ),
            );
          }
        }
      }

      // 6. Record treasury cash out (reversal of income) co-transactionally
      final latest = await (select(treasuryTransactions)
            ..orderBy([(t) => OrderingTerm.desc(t.id)])
            ..limit(1))
          .getSingleOrNull();
      final prevBalance = latest?.balanceAfter ?? 0.0;
      final newBalance = prevBalance - refundAmount;

      await into(treasuryTransactions).insert(
        TreasuryTransactionsCompanion.insert(
          shiftId: Value(activeShift.id),
          userId: userId,
          type: 'cash_out',
          amount: refundAmount,
          referenceType: const Value('transaction'),
          referenceId: Value(refundTxnId),
          description: Value('Refund for Transaction #$transactionId'),
          balanceAfter: newBalance,
        ),
      );

      // 7. Update Shift totalSales (subtract refund amount) co-transactionally
      await (update(shifts)..where((s) => s.id.equals(activeShift.id))).write(
        ShiftsCompanion(
          totalSales: Value(activeShift.totalSales - refundAmount),
        ),
      );

      return true;
    });
  }
}

// ── DTOs with Validation Guards (V-05) ─────────────────────────

/// Line item for a sale transaction (meal sold).
class SaleLineItem {
  final int mealId;
  final double quantity;
  final double priceAtTime;

  SaleLineItem({
    required this.mealId,
    required this.quantity,
    required this.priceAtTime,
  }) {
    assert(quantity > 0, 'Quantity must be greater than zero.');
    assert(priceAtTime >= 0, 'Price cannot be negative.');
  }
}

/// Line item for a waste transaction (ingredient wasted).
class WasteLineItem {
  final int ingredientId;
  final double quantity;

  WasteLineItem({
    required this.ingredientId,
    required this.quantity,
  }) {
    assert(quantity > 0, 'Quantity must be greater than zero.');
  }
}
