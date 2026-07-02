import '../entities/treasury_transaction_entity.dart';

abstract class TreasuryRepository {
  Future<double> getCurrentBalance();
  Future<List<TreasuryTransactionEntity>> getAllTransactions();
  Future<List<TreasuryTransactionEntity>> getTransactionsForShift(int shiftId);
  Stream<double> watchBalance();
  Future<int> addManualAdjustment({
    required int userId,
    required int? shiftId,
    required String type, // 'cash_in' or 'cash_out'
    required double amount,
    required String? description,
  });
}
