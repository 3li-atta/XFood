import 'package:equatable/equatable.dart';

/// Pure domain entity for Profit & Loss Report.
class ProfitLossReportEntity extends Equatable {
  final double totalRevenue;
  final double totalCOGS;
  final double totalWasteCost;
  final double totalPurchases;
  final double totalExpenses; // المصروفات التشغيلية
  final double netProfit;

  const ProfitLossReportEntity({
    required this.totalRevenue,
    required this.totalCOGS,
    required this.totalWasteCost,
    required this.totalPurchases,
    required this.totalExpenses,
    required this.netProfit,
  });

  @override
  List<Object?> get props => [
        totalRevenue,
        totalCOGS,
        totalWasteCost,
        totalPurchases,
        totalExpenses,
        netProfit,
      ];
}
