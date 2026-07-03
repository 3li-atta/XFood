import 'package:equatable/equatable.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

class LoadExpenses extends ExpenseEvent {
  final DateTime startDate;
  final DateTime endDate;

  const LoadExpenses({required this.startDate, required this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}

class AddExpense extends ExpenseEvent {
  final double amount;
  final String category;
  final String? note;
  final int userId;
  final int? activeShiftId;

  const AddExpense({
    required this.amount,
    required this.category,
    this.note,
    required this.userId,
    required this.activeShiftId,
  });

  @override
  List<Object?> get props => [amount, category, note, userId, activeShiftId];
}
