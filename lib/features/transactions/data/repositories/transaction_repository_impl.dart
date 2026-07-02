import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_item_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../../../database/app_database.dart';
import '../../../../database/daos/transaction_dao.dart';
import '../../../../database/daos/purchase_dao.dart';

/// Concrete implementation of [TransactionRepository] using Drift DAOs.
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionDao _transactionDao;
  final PurchaseDao _purchaseDao;

  TransactionRepositoryImpl(this._transactionDao, this._purchaseDao);

  @override
  Future<List<TransactionEntity>> getAllTransactions() async {
    final rows = await _transactionDao.getAllTransactions();
    final pRows = await _purchaseDao.getAllInvoices();

    final salesAndWaste = rows.map(_mapTxnToEntity).toList();
    final purchases = pRows.map(_mapPurchaseToEntity).toList();

    final combined = [...salesAndWaste, ...purchases];
    combined.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return combined;
  }

  @override
  Future<List<TransactionEntity>> getTransactionsByType(String type) async {
    if (type == 'purchase') {
      final pRows = await _purchaseDao.getAllInvoices();
      return pRows.map(_mapPurchaseToEntity).toList();
    }
    final rows = await _transactionDao.getTransactionsByType(type);
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
    required String? notes,
    required List<SaleInput> items,
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
}
