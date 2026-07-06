import 'package:equatable/equatable.dart';
import '../../domain/entities/product_mix_item.dart';
import '../../domain/entities/expense_breakdown_item.dart';
import '../../domain/entities/consumption_item.dart';
import '../../domain/entities/peak_hour_item.dart';
import '../../domain/entities/cashier_performance_item.dart';
import '../../../transactions/domain/entities/profit_loss_report_entity.dart';
import '../../../../database/app_database.dart';

abstract class ReportsState extends Equatable {
  const ReportsState();

  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsLoaded extends ReportsState {
  final List<ProductMixItem> productMix;
  final List<ExpenseBreakdownItem> expenseBreakdown;
  final List<Expense> detailedExpenses;
  final List<ConsumptionItem> inventoryConsumption;
  final List<PeakHourItem> peakHours;
  final List<CashierPerformanceItem> cashierPerformance;
  final ProfitLossReportEntity profitLoss;
  final DateTime startDate;
  final DateTime endDate;

  const ReportsLoaded({
    required this.productMix,
    required this.expenseBreakdown,
    required this.detailedExpenses,
    required this.inventoryConsumption,
    required this.peakHours,
    required this.cashierPerformance,
    required this.profitLoss,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [
        productMix,
        expenseBreakdown,
        detailedExpenses,
        inventoryConsumption,
        peakHours,
        cashierPerformance,
        profitLoss,
        startDate,
        endDate,
      ];
}

class ReportsError extends ReportsState {
  final String errorMessage;

  const ReportsError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
