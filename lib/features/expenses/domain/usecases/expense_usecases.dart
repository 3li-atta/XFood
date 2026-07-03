import '../../../../database/app_database.dart';
import '../repositories/expense_repository.dart';

class RecordExpenseUseCase {
  final ExpenseRepository _repository;

  RecordExpenseUseCase(this._repository);

  Future<int> call({
    required double amount,
    required DateTime date,
    required String category,
    required String? note,
    required int userId,
    required int? activeShiftId,
  }) {
    return _repository.recordExpense(
      amount: amount,
      date: date,
      category: category,
      note: note,
      userId: userId,
      activeShiftId: activeShiftId,
    );
  }
}

class GetExpensesUseCase {
  final ExpenseRepository _repository;

  GetExpensesUseCase(this._repository);

  Future<List<Expense>> call(DateTime start, DateTime end) {
    return _repository.getExpenses(start, end);
  }
}
