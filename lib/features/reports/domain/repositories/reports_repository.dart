import '../entities/product_mix_item.dart';
import '../entities/expense_breakdown_item.dart';
import '../entities/consumption_item.dart';
import '../entities/peak_hour_item.dart';
import '../entities/cashier_performance_item.dart';

abstract class ReportsRepository {
  Future<List<ProductMixItem>> getProductMixReport({
    required DateTime start,
    required DateTime end,
    required String sortBy,
  });

  Future<List<ExpenseBreakdownItem>> getExpenseBreakdownReport({
    required DateTime start,
    required DateTime end,
  });

  Future<List<ConsumptionItem>> getInventoryConsumptionReport({
    required DateTime start,
    required DateTime end,
  });

  Future<List<PeakHourItem>> getPeakHoursReport({
    required DateTime start,
    required DateTime end,
  });

  Future<List<CashierPerformanceItem>> getCashierPerformanceReport({
    required DateTime start,
    required DateTime end,
  });
}
