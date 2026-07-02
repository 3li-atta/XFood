import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/treasury_transactions_table.dart';
import '../tables/shifts_table.dart';

part 'treasury_dao.g.dart';

@DriftAccessor(tables: [TreasuryTransactions, Shifts])
class TreasuryDao extends DatabaseAccessor<AppDatabase> with _$TreasuryDaoMixin {
  TreasuryDao(super.db);

  /// Get current balance (latest transaction's balanceAfter or 0.0)
  Future<double> getCurrentBalance() async {
    final latest = await (select(treasuryTransactions)
          ..orderBy([(t) => OrderingTerm.desc(t.id)])
          ..limit(1))
        .getSingleOrNull();
    return latest?.balanceAfter ?? 0.0;
  }

  /// Get all treasury transactions
  Future<List<TreasuryTransaction>> getAllTransactions() {
    return (select(treasuryTransactions)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Get treasury transactions for a shift
  Future<List<TreasuryTransaction>> getTransactionsForShift(int shiftId) {
    return (select(treasuryTransactions)
          ..where((t) => t.shiftId.equals(shiftId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Watch current balance
  Stream<double> watchBalance() {
    return (select(treasuryTransactions)
          ..orderBy([(t) => OrderingTerm.desc(t.id)])
          ..limit(1))
        .watch()
        .map((list) => list.isNotEmpty ? list.first.balanceAfter : 0.0);
  }

  /// Record manual cash in/out transaction
  Future<int> insertManualAdjustment({
    required int userId,
    required int? shiftId,
    required String type, // 'cash_in' or 'cash_out'
    required double amount,
    required String? description,
  }) {
    return transaction(() async {
      final latest = await (select(treasuryTransactions)
            ..orderBy([(t) => OrderingTerm.desc(t.id)])
            ..limit(1))
          .getSingleOrNull();
      final prevBalance = latest?.balanceAfter ?? 0.0;
      final newBalance = type == 'cash_in' ? (prevBalance + amount) : (prevBalance - amount);

      final txnId = await into(treasuryTransactions).insert(
        TreasuryTransactionsCompanion.insert(
          shiftId: Value(shiftId),
          userId: userId,
          type: type,
          amount: amount,
          referenceType: const Value('manual'),
          description: Value(description),
          balanceAfter: newBalance,
        ),
      );

      // If shiftId is provided, update totalCashIn or totalCashOut
      if (shiftId != null) {
        final activeShift = await (select(shifts)..where((s) => s.id.equals(shiftId))).getSingle();
        if (activeShift.status != 'open') {
          throw Exception('Shift is not open');
        }
        if (type == 'cash_in') {
          await (update(shifts)..where((s) => s.id.equals(shiftId))).write(
            ShiftsCompanion(
              totalCashIn: Value(activeShift.totalCashIn + amount),
            ),
          );
        } else {
          await (update(shifts)..where((s) => s.id.equals(shiftId))).write(
            ShiftsCompanion(
              totalCashOut: Value(activeShift.totalCashOut + amount),
            ),
          );
        }
      }

      return txnId;
    });
  }
}
