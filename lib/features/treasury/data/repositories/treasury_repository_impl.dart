import '../../domain/entities/treasury_transaction_entity.dart';
import '../../domain/repositories/treasury_repository.dart';
import '../../../../database/app_database.dart';
import '../../../../database/daos/treasury_dao.dart';

class TreasuryRepositoryImpl implements TreasuryRepository {
  final TreasuryDao _treasuryDao;

  TreasuryRepositoryImpl(this._treasuryDao);

  @override
  Future<double> getCurrentBalance() {
    return _treasuryDao.getCurrentBalance();
  }

  @override
  Future<List<TreasuryTransactionEntity>> getAllTransactions() async {
    final rows = await _treasuryDao.getAllTransactions();
    return rows.map(_mapToEntity).toList();
  }

  @override
  Future<List<TreasuryTransactionEntity>> getTransactionsPaginated(int limit, int offset) async {
    final rows = await _treasuryDao.getTransactionsPaginated(limit, offset);
    return rows.map(_mapToEntity).toList();
  }

  @override
  Future<List<TreasuryTransactionEntity>> getTransactionsForShift(int shiftId) async {
    final rows = await _treasuryDao.getTransactionsForShift(shiftId);
    return rows.map(_mapToEntity).toList();
  }

  @override
  Stream<double> watchBalance() {
    return _treasuryDao.watchBalance();
  }

  @override
  Future<int> addManualAdjustment({
    required int userId,
    required int? shiftId,
    required String type,
    required double amount,
    required String? description,
  }) {
    return _treasuryDao.insertManualAdjustment(
      userId: userId,
      shiftId: shiftId,
      type: type,
      amount: amount,
      description: description,
    );
  }

  TreasuryTransactionEntity _mapToEntity(TreasuryTransaction row) {
    return TreasuryTransactionEntity(
      id: row.id,
      shiftId: row.shiftId,
      userId: row.userId,
      type: row.type,
      amount: row.amount,
      referenceType: row.referenceType,
      referenceId: row.referenceId,
      description: row.description,
      balanceAfter: row.balanceAfter,
      createdAt: row.createdAt,
    );
  }
}
