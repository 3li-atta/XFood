import '../../domain/repositories/reports_repository.dart';
import '../../domain/entities/product_mix_item.dart';
import '../../domain/entities/expense_breakdown_item.dart';
import '../../domain/entities/consumption_item.dart';
import '../../domain/entities/peak_hour_item.dart';
import '../../domain/entities/cashier_performance_item.dart';
import '../../../../database/daos/reports_dao.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsDao _reportsDao;

  ReportsRepositoryImpl(this._reportsDao);

  @override
  Future<List<ProductMixItem>> getProductMixReport({
    required DateTime start,
    required DateTime end,
    required String sortBy,
  }) async {
    final rows = await _reportsDao.getProductMixReport(start, end, sortBy: sortBy);
    final double totalRevenueSum = rows.fold(0.0, (sum, row) => sum + row.totalRevenue);

    return rows.map((row) {
      final double percentage = totalRevenueSum > 0 ? (row.totalRevenue / totalRevenueSum) * 100 : 0.0;
      return ProductMixItem(
        mealId: row.mealId,
        mealName: row.mealName,
        category: row.category,
        totalQuantity: row.totalQty,
        totalRevenue: row.totalRevenue,
        revenuePercentage: percentage,
      );
    }).toList();
  }

  @override
  Future<List<ExpenseBreakdownItem>> getExpenseBreakdownReport({
    required DateTime start,
    required DateTime end,
  }) async {
    final rows = await _reportsDao.getExpenseBreakdown(start, end);
    final double totalExpenses = rows.fold(0.0, (sum, row) => sum + row.categoryTotal);

    return rows.map((row) {
      final double percentage = totalExpenses > 0 ? (row.categoryTotal / totalExpenses) * 100 : 0.0;
      return ExpenseBreakdownItem(
        category: row.category,
        entryCount: row.entryCount,
        categoryTotal: row.categoryTotal,
        percentage: percentage,
      );
    }).toList();
  }

  @override
  Future<List<ConsumptionItem>> getInventoryConsumptionReport({
    required DateTime start,
    required DateTime end,
  }) async {
    final standardRows = await _reportsDao.getStandardConsumption(start, end);
    final wasteRows = await _reportsDao.getWasteConsumption(start, end);

    final Map<int, _IngredientTempData> tempMap = {};

    for (final row in standardRows) {
      tempMap[row.ingredientId] = _IngredientTempData(
        id: row.ingredientId,
        name: row.ingredientName,
        unit: row.unit,
        standard: row.usageAmount,
        waste: 0.0,
      );
    }

    for (final row in wasteRows) {
      if (tempMap.containsKey(row.ingredientId)) {
        final existing = tempMap[row.ingredientId]!;
        tempMap[row.ingredientId] = existing.copyWith(waste: row.usageAmount);
      } else {
        tempMap[row.ingredientId] = _IngredientTempData(
          id: row.ingredientId,
          name: row.ingredientName,
          unit: row.unit,
          standard: 0.0,
          waste: row.usageAmount,
        );
      }
    }

    return tempMap.values.map((temp) {
      final total = temp.standard + temp.waste;
      final wasteRatio = total > 0 ? (temp.waste / total) * 100 : 0.0;
      return ConsumptionItem(
        ingredientId: temp.id,
        ingredientName: temp.name,
        unit: temp.unit,
        standardUsage: temp.standard,
        wasteUsage: temp.waste,
        totalConsumed: total,
        wasteRatio: wasteRatio,
      );
    }).toList();
  }

  @override
  Future<List<PeakHourItem>> getPeakHoursReport({
    required DateTime start,
    required DateTime end,
  }) async {
    final rows = await _reportsDao.getPeakHoursAnalysis(start, end);
    return rows.map((row) {
      return PeakHourItem(
        hourOfDay: row.hourOfDay,
        transactionCount: row.transactionCount,
        totalRevenue: row.totalRevenue,
      );
    }).toList();
  }

  @override
  Future<List<CashierPerformanceItem>> getCashierPerformanceReport({
    required DateTime start,
    required DateTime end,
  }) async {
    final rows = await _reportsDao.getCashierPerformance(start, end);
    return rows.map((row) {
      return CashierPerformanceItem(
        userId: row.userId,
        cashierName: row.cashierName,
        totalShifts: row.totalShifts,
        totalSales: row.totalSales,
        shortageCount: row.shortageCount,
        totalShortage: row.totalShortage,
        totalSurplus: row.totalSurplus,
        avgVariance: row.avgVariance,
      );
    }).toList();
  }
}

class _IngredientTempData {
  final int id;
  final String name;
  final String unit;
  final double standard;
  final double waste;

  _IngredientTempData({
    required this.id,
    required this.name,
    required this.unit,
    required this.standard,
    required this.waste,
  });

  _IngredientTempData copyWith({double? waste}) {
    return _IngredientTempData(
      id: id,
      name: name,
      unit: unit,
      standard: standard,
      waste: waste ?? this.waste,
    );
  }
}
