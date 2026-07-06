import 'package:equatable/equatable.dart';

/// Entity for a single category in the Expense Breakdown Report.
class ExpenseBreakdownItem extends Equatable {
  final String category;
  final int entryCount;
  final double categoryTotal;
  final double percentage; // Calculated in repository

  const ExpenseBreakdownItem({
    required this.category,
    required this.entryCount,
    required this.categoryTotal,
    this.percentage = 0.0,
  });

  ExpenseBreakdownItem copyWith({double? percentage}) {
    return ExpenseBreakdownItem(
      category: category,
      entryCount: entryCount,
      categoryTotal: categoryTotal,
      percentage: percentage ?? this.percentage,
    );
  }

  @override
  List<Object?> get props => [category, entryCount, categoryTotal, percentage];
}
