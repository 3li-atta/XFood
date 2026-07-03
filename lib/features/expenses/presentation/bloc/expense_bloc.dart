import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/expense_usecases.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final RecordExpenseUseCase _recordExpenseUseCase;
  final GetExpensesUseCase _getExpensesUseCase;

  ExpenseBloc({
    required RecordExpenseUseCase recordExpenseUseCase,
    required GetExpensesUseCase getExpensesUseCase,
  })  : _recordExpenseUseCase = recordExpenseUseCase,
        _getExpensesUseCase = getExpensesUseCase,
        super(ExpenseInitial()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<AddExpense>(_onAddExpense);
  }

  Future<void> _onLoadExpenses(LoadExpenses event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    try {
      final expenses = await _getExpensesUseCase(event.startDate, event.endDate);
      emit(ExpenseLoaded(expenses));
    } catch (e) {
      emit(ExpenseFailure('فشل تحميل المصروفات: ${e.toString()}'));
    }
  }

  Future<void> _onAddExpense(AddExpense event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    try {
      await _recordExpenseUseCase(
        amount: event.amount,
        date: DateTime.now(),
        category: event.category,
        note: event.note,
        userId: event.userId,
        activeShiftId: event.activeShiftId,
      );
      emit(const ExpenseSuccess('تم تسجيل المصروف بنجاح وخصمه من درج الكاش.'));
    } catch (e) {
      emit(ExpenseFailure('فشل تسجيل المصروف: ${e.toString()}'));
    }
  }
}
