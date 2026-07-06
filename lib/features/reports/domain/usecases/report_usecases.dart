import '../repositories/reports_repository.dart';
import '../entities/product_mix_item.dart';
import '../entities/expense_breakdown_item.dart';
import '../entities/consumption_item.dart';
import '../entities/peak_hour_item.dart';
import '../entities/cashier_performance_item.dart';

class GetProductMixUseCase {
  final ReportsRepository _repository;

  GetProductMixUseCase(this._repository);

  Future<List<ProductMixItem>> call({
    required DateTime start,
    required DateTime end,
    required String sortBy,
  }) {
    return _repository.getProductMixReport(start: start, end: end, sortBy: sortBy);
  }
}

class GetExpenseBreakdownUseCase {
  final ReportsRepository _repository;

  GetExpenseBreakdownUseCase(this._repository);

  Future<List<ExpenseBreakdownItem>> call({
    required DateTime start,
    required DateTime end,
  }) {
    return _repository.getExpenseBreakdownReport(start: start, end: end);
  }
}

class GetInventoryConsumptionUseCase {
  final ReportsRepository _repository;

  GetInventoryConsumptionUseCase(this._repository);

  Future<List<ConsumptionItem>> call({
    required DateTime start,
    required DateTime end,
  }) {
    return _repository.getInventoryConsumptionReport(start: start, end: end);
  }
}

class GetPeakHoursUseCase {
  final ReportsRepository _repository;

  GetPeakHoursUseCase(this._repository);

  Future<List<PeakHourItem>> call({
    required DateTime start,
    required DateTime end,
  }) {
    return _repository.getPeakHoursReport(start: start, end: end);
  }
}

class GetCashierPerformanceUseCase {
  final ReportsRepository _repository;

  GetCashierPerformanceUseCase(this._repository);

  Future<List<CashierPerformanceItem>> call({
    required DateTime start,
    required DateTime end,
  }) {
    return _repository.getCashierPerformanceReport(start: start, end: end);
  }
}
