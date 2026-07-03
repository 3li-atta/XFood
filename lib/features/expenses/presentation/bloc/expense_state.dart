import 'package:equatable/equatable.dart';
import '../../../../database/app_database.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object?> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;

  const ExpenseLoaded(this.expenses);

  @override
  List<Object?> get props => [expenses];
}

class ExpenseSuccess extends ExpenseState {
  final String message;

  const ExpenseSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ExpenseFailure extends ExpenseState {
  final String errorMessage;

  const ExpenseFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
