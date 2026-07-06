import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/report_usecases.dart';
import '../../domain/entities/product_mix_item.dart';
import '../../domain/entities/expense_breakdown_item.dart';
import '../../domain/entities/consumption_item.dart';
import '../../domain/entities/peak_hour_item.dart';
import '../../domain/entities/cashier_performance_item.dart';
import '../../../expenses/domain/usecases/expense_usecases.dart';
import '../../../transactions/domain/usecases/get_profit_loss_usecase.dart';
import '../../../transactions/domain/entities/profit_loss_report_entity.dart';
import '../../../../database/app_database.dart';
import 'reports_event.dart';
import 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final GetProductMixUseCase _getProductMixUseCase;
  final GetExpenseBreakdownUseCase _getExpenseBreakdownUseCase;
  final GetInventoryConsumptionUseCase _getInventoryConsumptionUseCase;
  final GetPeakHoursUseCase _getPeakHoursUseCase;
  final GetCashierPerformanceUseCase _getCashierPerformanceUseCase;
  final GetExpensesUseCase _getExpensesUseCase;
  final GetProfitLossUseCase _getProfitLossUseCase;

  ReportsBloc({
    required GetProductMixUseCase getProductMixUseCase,
    required GetExpenseBreakdownUseCase getExpenseBreakdownUseCase,
    required GetInventoryConsumptionUseCase getInventoryConsumptionUseCase,
    required GetPeakHoursUseCase getPeakHoursUseCase,
    required GetCashierPerformanceUseCase getCashierPerformanceUseCase,
    required GetExpensesUseCase getExpensesUseCase,
    required GetProfitLossUseCase getProfitLossUseCase,
  })  : _getProductMixUseCase = getProductMixUseCase,
        _getExpenseBreakdownUseCase = getExpenseBreakdownUseCase,
        _getInventoryConsumptionUseCase = getInventoryConsumptionUseCase,
        _getPeakHoursUseCase = getPeakHoursUseCase,
        _getCashierPerformanceUseCase = getCashierPerformanceUseCase,
        _getExpensesUseCase = getExpensesUseCase,
        _getProfitLossUseCase = getProfitLossUseCase,
        super(ReportsInitial()) {
    on<LoadAllReportsEvent>(_onLoadAllReports);
  }

  Future<void> _onLoadAllReports(
    LoadAllReportsEvent event,
    Emitter<ReportsState> emit,
  ) async {
    emit(ReportsLoading());
    try {
      // Execute all report queries in parallel
      final results = await Future.wait([
        _getProductMixUseCase(start: event.startDate, end: event.endDate, sortBy: 'revenue'),
        _getExpenseBreakdownUseCase(start: event.startDate, end: event.endDate),
        _getExpensesUseCase(event.startDate, event.endDate),
        _getInventoryConsumptionUseCase(start: event.startDate, end: event.endDate),
        _getPeakHoursUseCase(start: event.startDate, end: event.endDate),
        _getCashierPerformanceUseCase(start: event.startDate, end: event.endDate),
        _getProfitLossUseCase(GetProfitLossParams(start: event.startDate, end: event.endDate)),
      ]);

      emit(ReportsLoaded(
        productMix: results[0] as List<ProductMixItem>,
        expenseBreakdown: results[1] as List<ExpenseBreakdownItem>,
        detailedExpenses: results[2] as List<Expense>,
        inventoryConsumption: results[3] as List<ConsumptionItem>,
        peakHours: results[4] as List<PeakHourItem>,
        cashierPerformance: results[5] as List<CashierPerformanceItem>,
        profitLoss: results[6] as ProfitLossReportEntity,
        startDate: event.startDate,
        endDate: event.endDate,
      ));
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }
}
