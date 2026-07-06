import 'package:equatable/equatable.dart';

/// Entity for a single cashier row in the Cashier Performance Report.
class CashierPerformanceItem extends Equatable {
  final int userId;
  final String cashierName;
  final int totalShifts;
  final double totalSales;
  final int shortageCount;
  final double totalShortage;
  final double totalSurplus;
  final double avgVariance;

  const CashierPerformanceItem({
    required this.userId,
    required this.cashierName,
    required this.totalShifts,
    required this.totalSales,
    required this.shortageCount,
    required this.totalShortage,
    required this.totalSurplus,
    required this.avgVariance,
  });

  @override
  List<Object?> get props => [
        userId,
        cashierName,
        totalShifts,
        totalSales,
        shortageCount,
        totalShortage,
        totalSurplus,
        avgVariance,
      ];
}
