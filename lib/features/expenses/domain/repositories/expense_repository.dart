import '../../../../database/app_database.dart';

abstract class ExpenseRepository {
  Future<int> recordExpense({
    required double amount,
    required DateTime date,
    required String category,
    required String? note,
    required int userId,
    required int? activeShiftId,
  });

  Future<List<Expense>> getExpenses(DateTime start, DateTime end);

  Future<double> getTotalExpenses(DateTime start, DateTime end);
}
