import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_item_entity.dart';
import '../../domain/entities/profit_loss_report_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../../../database/app_database.dart';
import '../../../../database/daos/transaction_dao.dart';
import '../../../../database/daos/purchase_dao.dart';
import '../../../../database/daos/expense_dao.dart';

/// Concrete implementation of [TransactionRepository] using Drift DAOs.
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionDao _transactionDao;
  final PurchaseDao _purchaseDao;
  final ExpenseDao _expenseDao;

  TransactionRepositoryImpl(this._transactionDao, this._purchaseDao, this._expenseDao);

  @override
  Future<List<TransactionEntity>> getAllTransactions({int limit = 50, int offset = 0}) async {
    final rows = await _transactionDao.getCombinedTransactionsPaginated(limit, offset);
    return rows.map(_mapTxnToEntity).toList();
  }

  @override
  Future<List<TransactionEntity>> getTransactionsByType(String type, {int limit = 50, int offset = 0}) async {
    if (type == 'purchase') {
      final pRows = await _purchaseDao.getAllInvoicesPaginated(limit, offset);
      return pRows.map(_mapPurchaseToEntity).toList();
    }
    if (type == 'expense') {
      final eRows = await _expenseDao.getAllExpensesPaginated(limit, offset);
      return eRows.map(_mapExpenseToEntity).toList();
    }
    final rows = await _transactionDao.getTransactionsByTypePaginated(type, limit, offset);
    return rows.map(_mapTxnToEntity).toList();
  }

  @override
  Future<List<TransactionEntity>> getTransactionsByDateRange(
      DateTime start, DateTime end) async {
    final rows = await _transactionDao.getTransactionsByDateRange(start, end);
    return rows.map(_mapTxnToEntity).toList();
  }

  @override
  Future<List<TransactionItemEntity>> getTransactionItems(
      int transactionId, {String? type}) async {
    if (type == 'purchase') {
      final items = await _purchaseDao.getItemsForInvoice(transactionId);
      return items.map((row) => TransactionItemEntity(
        id: row.id,
        transactionId: row.purchaseInvoiceId,
        mealId: null,
        ingredientId: row.ingredientId,
        quantity: row.quantity,
        priceAtTime: row.unitCost,
        itemType: 'ingredient',
      )).toList();
    }
    if (type == 'expense') {
      final exp = await _expenseDao.getExpenseById(transactionId);
      if (exp != null) {
        return [
          TransactionItemEntity(
            id: exp.id,
            transactionId: exp.id,
            mealId: null,
            ingredientId: null,
            quantity: 1.0,
            priceAtTime: exp.amount,
            itemType: 'expense',
          )
        ];
      }
      return [];
    }
    final rows = await _transactionDao.getItemsForTransaction(transactionId);
    return rows.map(_mapItemToEntity).toList();
  }

  @override
  Stream<List<TransactionEntity>> watchAllTransactions() {
    return _transactionDao.watchAllTransactions().map(
          (rows) => rows.map(_mapTxnToEntity).toList(),
        );
  }

  @override
  Future<int> createSale({
    required int userId,
    required int? shiftId,
    required double totalAmount,
    required double discountPercentage,
    required double taxPercentage,
    required List<SaleInput> items,
    String? notes,
    String orderType = 'takeaway',
    String paymentMethod = 'cash',
    int? tableId,
  }) {
    return _transactionDao.createSaleWithStockDeduction(
      userId: userId,
      shiftId: shiftId,
      notes: notes,
      lineItems: items
          .map((i) => SaleLineItem(
                mealId: i.mealId,
                quantity: i.quantity,
                priceAtTime: i.priceAtTime,
              ))
          .toList(),
      discountPercentage: discountPercentage,
      taxPercentage: taxPercentage,
      orderType: orderType,
      paymentMethod: paymentMethod,
      tableId: tableId,
    );
  }

  @override
  Future<int> recordWaste({
    required int userId,
    required String? notes,
    required List<WasteInput> items,
  }) {
    return _transactionDao.recordWaste(
      userId: userId,
      notes: notes,
      lineItems: items
          .map((i) => WasteLineItem(
                ingredientId: i.ingredientId,
                quantity: i.quantity,
              ))
          .toList(),
    );
  }

  TransactionEntity _mapTxnToEntity(Transaction row) {
    return TransactionEntity(
      id: row.id,
      userId: row.userId,
      type: row.type,
      totalAmount: row.totalAmount,
      notes: row.notes,
      createdAt: row.createdAt,
    );
  }

  TransactionItemEntity _mapItemToEntity(TransactionItem row) {
    return TransactionItemEntity(
      id: row.id,
      transactionId: row.transactionId,
      mealId: row.mealId,
      ingredientId: row.ingredientId,
      quantity: row.quantity,
      priceAtTime: row.priceAtTime,
      itemType: row.itemType,
    );
  }

  TransactionEntity _mapPurchaseToEntity(PurchaseInvoice row) {
    return TransactionEntity(
      id: row.id,
      userId: row.userId,
      type: 'purchase',
      totalAmount: row.totalAmount,
      notes: row.notes,
      createdAt: row.createdAt,
    );
  }

  TransactionEntity _mapExpenseToEntity(Expense row) {
    return TransactionEntity(
      id: row.id,
      userId: 0,
      type: 'expense',
      totalAmount: row.amount,
      notes: 'الفئة: ${row.category}${row.note != null ? " • ${row.note}" : ""}',
      createdAt: row.date,
    );
  }

  @override
  Future<ProfitLossReportEntity> getProfitLossReport(DateTime start, DateTime end) async {
    final txns = await _transactionDao.getTransactionsByDateRange(start, end);
    
    double totalRevenue = 0.0;
    double totalWasteCost = 0.0;
    
    for (final t in txns) {
      if (t.type == 'sale') {
        totalRevenue += t.totalAmount;
      } else if (t.type == 'refund') {
        totalRevenue -= t.totalAmount;
      } else if (t.type == 'waste') {
        totalWasteCost += t.totalAmount;
      }
    }

    final totalCOGS = await _transactionDao.getCOGSForDateRange(start, end);

    final purchaseInvoices = await _purchaseDao.getInvoicesByDateRange(start, end);
    double totalPurchases = 0.0;
    for (final pi in purchaseInvoices) {
      totalPurchases += pi.totalAmount;
    }

    final expenseList = await _expenseDao.getExpensesForDateRange(start, end);
    double totalExpenses = 0.0;
    final Map<String, double> expensesByCategory = {};
    for (final exp in expenseList) {
      totalExpenses += exp.amount;
      expensesByCategory[exp.category] = (expensesByCategory[exp.category] ?? 0.0) + exp.amount;
    }

    final netProfit = totalRevenue - totalCOGS - totalWasteCost - totalExpenses;

    return ProfitLossReportEntity(
      totalRevenue: totalRevenue,
      totalCOGS: totalCOGS,
      totalWasteCost: totalWasteCost,
      totalPurchases: totalPurchases,
      totalExpenses: totalExpenses,
      netProfit: netProfit,
      expensesByCategory: expensesByCategory,
    );
  }

  @override
  Future<bool> refundSaleTransaction(int transactionId, int userId, String reason) {
    return _transactionDao.refundSaleTransaction(
      transactionId: transactionId,
      userId: userId,
      reason: reason,
    );
  }

  @override
  Future<bool> isTransactionRefunded(int transactionId) {
    return _transactionDao.isTransactionRefunded(transactionId);
  }
}
