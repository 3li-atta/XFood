import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/shifts_table.dart';
import '../tables/treasury_transactions_table.dart';

part 'shift_dao.g.dart';

@DriftAccessor(tables: [Shifts, TreasuryTransactions])
class ShiftDao extends DatabaseAccessor<AppDatabase> with _$ShiftDaoMixin {
  ShiftDao(super.db);

  /// Get the active open shift for a cashier, if any.
  Future<Shift?> getActiveShift(int cashierId) {
    return (select(shifts)
          ..where((s) => s.cashierId.equals(cashierId) & s.status.equals('open')))
        .getSingleOrNull();
  }

  /// Watch active open shift.
  Stream<Shift?> watchActiveShift(int cashierId) {
    return (select(shifts)
          ..where((s) => s.cashierId.equals(cashierId) & s.status.equals('open')))
        .watchSingleOrNull();
  }

  /// Open a new shift.
  Future<int> openShift({
    required int cashierId,
    required double startingCash,
  }) {
    return transaction(() async {
      // Ensure no active open shift exists for cashier
      final active = await getActiveShift(cashierId);
      if (active != null) {
        throw Exception('An active shift is already open for this user.');
      }

      final shiftId = await into(shifts).insert(
        ShiftsCompanion.insert(
          cashierId: cashierId,
          startingCash: startingCash,
          status: const Value('open'),
        ),
      );

      // Create TreasuryTransaction for shift opening cash
      final latest = await (select(treasuryTransactions)
            ..orderBy([(t) => OrderingTerm.desc(t.id)])
            ..limit(1))
          .getSingleOrNull();
      final prevBalance = latest?.balanceAfter ?? 0.0;
      final newBalance = prevBalance + startingCash;

      await into(treasuryTransactions).insert(
        TreasuryTransactionsCompanion.insert(
          shiftId: Value(shiftId),
          userId: cashierId,
          type: 'shift_open',
          amount: startingCash,
          referenceType: const Value('manual'),
          description: Value('Opening cash (العهدة) for shift #$shiftId'),
          balanceAfter: newBalance,
        ),
      );

      return shiftId;
    });
  }

  /// Close an active shift.
  Future<void> closeShift({
    required int shiftId,
    required double actualClosingCash,
    required String? notes,
  }) {
    return transaction(() async {
      final shift = await (select(shifts)..where((s) => s.id.equals(shiftId))).getSingle();
      if (shift.status != 'open') {
        throw Exception('This shift is already closed.');
      }

      // Compute expected closing cash
      final expectedClosingCash = shift.startingCash + shift.totalSales - shift.totalPurchases + shift.totalCashIn - shift.totalCashOut;
      final variance = actualClosingCash - expectedClosingCash;

      // Close the shift in the database
      await (update(shifts)..where((s) => s.id.equals(shiftId))).write(
        ShiftsCompanion(
          status: const Value('closed'),
          expectedClosingCash: Value(expectedClosingCash),
          actualClosingCash: Value(actualClosingCash),
          variance: Value(variance),
          closedAt: Value(DateTime.now()),
          notes: Value(notes),
        ),
      );

      // Record treasury transaction for shift closing
      final latest = await (select(treasuryTransactions)
            ..orderBy([(t) => OrderingTerm.desc(t.id)])
            ..limit(1))
          .getSingleOrNull();
      final prevBalance = latest?.balanceAfter ?? 0.0;
      
      // Shift close logs reconciled state snapshot
      await into(treasuryTransactions).insert(
        TreasuryTransactionsCompanion.insert(
          shiftId: Value(shiftId),
          userId: shift.cashierId,
          type: 'shift_close',
          amount: actualClosingCash,
          referenceType: const Value('manual'),
          description: Value('Closing cash count for shift #$shiftId. Reconciled variance: $variance'),
          balanceAfter: prevBalance,
        ),
      );
    });
  }

  /// Get shift history.
  Future<List<Shift>> getShiftHistory() {
    return (select(shifts)..orderBy([(s) => OrderingTerm.desc(s.openedAt)])).get();
  }

  /// Get a single shift by id.
  Future<Shift> getById(int id) {
    return (select(shifts)..where((s) => s.id.equals(id))).getSingle();
  }
}
