import 'package:drift/drift.dart';
import '../../../../database/app_database.dart';
import '../../domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final AppDatabase _db;

  ExpenseRepositoryImpl(this._db);

  @override
  Future<int> recordExpense({
    required double amount,
    required DateTime date,
    required String category,
    required String? note,
    required int userId,
    required int? activeShiftId,
  }) {
    return _db.transaction(() async {
      // 1. Insert into expenses table
      final expenseId = await _db.expenseDao.insertExpense(
        ExpensesCompanion.insert(
          amount: amount,
          date: date,
          category: category,
          note: Value(note),
          shiftId: Value(activeShiftId),
        ),
      );

      // 2. Insert into treasury transactions and update shift drawer
      final description = 'مصروف: $category${note != null && note.isNotEmpty ? " - $note" : ""}';
      await _db.treasuryDao.insertManualAdjustment(
        userId: userId,
        shiftId: activeShiftId,
        type: 'cash_out',
        amount: amount,
        description: description,
      );

      return expenseId;
    });
  }

  @override
  Future<List<Expense>> getExpenses(DateTime start, DateTime end) {
    return _db.expenseDao.getExpensesForDateRange(start, end);
  }

  @override
  Future<double> getTotalExpenses(DateTime start, DateTime end) {
    return _db.expenseDao.getTotalExpensesForDateRange(start, end);
  }
}
