import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/transactions_table.dart';
import '../tables/transaction_items_table.dart';
import '../tables/meals_table.dart';
import '../tables/recipes_table.dart';
import '../tables/ingredients_table.dart';
import '../tables/expenses_table.dart';
import '../tables/shifts_table.dart';
import '../tables/users_table.dart';

part 'reports_dao.g.dart';

/// Data Access Object for all Analytics & Reporting queries.
///
/// Contains efficient custom SQL aggregations for:
/// 1. Product Mix / Item Sales Report
/// 2. Expense Breakdown by Category
/// 3. Inventory Consumption (Standard + Waste)
/// 4. Peak Hours Analysis
/// 5. Cashier Performance & Cash Variance
@DriftAccessor(tables: [
  Transactions,
  TransactionItems,
  Meals,
  Recipes,
  Ingredients,
  Expenses,
  Shifts,
  Users,
])
class ReportsDao extends DatabaseAccessor<AppDatabase>
    with _$ReportsDaoMixin {
  ReportsDao(super.db);

  // ── Report 1: Product Mix / Item Sales ────────────────────

  /// Aggregates meal sales by item for a given date range.
  ///
  /// Returns rows with: mealId, mealName, category, totalQty, totalRevenue.
  /// [sortBy] can be 'quantity' or 'revenue' (default: 'revenue').
  Future<List<ProductMixRow>> getProductMixReport(
    DateTime start,
    DateTime end, {
    String sortBy = 'revenue',
  }) async {
    final orderClause = sortBy == 'quantity'
        ? 'ORDER BY total_qty DESC'
        : 'ORDER BY total_revenue DESC';

    final rows = await customSelect(
      'SELECT '
      '  m.id AS meal_id, '
      '  m.name AS meal_name, '
      '  m.category AS category, '
      '  SUM(ti.quantity) AS total_qty, '
      '  SUM(ti.quantity * ti.price_at_time) AS total_revenue '
      'FROM transaction_items ti '
      '  JOIN transactions t ON ti.transaction_id = t.id '
      '  JOIN meals m ON ti.meal_id = m.id '
      'WHERE t.type = \'sale\' '
      '  AND t.created_at >= ? AND t.created_at <= ? '
      'GROUP BY m.id '
      '$orderClause',
      variables: [Variable<DateTime>(start), Variable<DateTime>(end)],
      readsFrom: {transactionItems, transactions, meals},
    ).get();

    return rows.map((row) => ProductMixRow(
      mealId: row.read<int>('meal_id'),
      mealName: row.read<String>('meal_name'),
      category: row.read<String>('category'),
      totalQty: row.read<double>('total_qty'),
      totalRevenue: row.read<double>('total_revenue'),
    )).toList();
  }

  // ── Report 2: Expense Breakdown by Category ───────────────

  /// Aggregates expenses by category for a given date range.
  Future<List<ExpenseBreakdownRow>> getExpenseBreakdown(
    DateTime start,
    DateTime end,
  ) async {
    final rows = await customSelect(
      'SELECT '
      '  category, '
      '  COUNT(*) AS entry_count, '
      '  SUM(amount) AS category_total '
      'FROM expenses '
      'WHERE date >= ? AND date <= ? '
      'GROUP BY category '
      'ORDER BY category_total DESC',
      variables: [Variable<DateTime>(start), Variable<DateTime>(end)],
      readsFrom: {expenses},
    ).get();

    return rows.map((row) => ExpenseBreakdownRow(
      category: row.read<String>('category'),
      entryCount: row.read<int>('entry_count'),
      categoryTotal: row.read<double>('category_total'),
    )).toList();
  }

  // ── Report 3: Inventory Consumption ───────────────────────

  /// Standard ingredient usage from sold meals (sales × recipes).
  Future<List<ConsumptionRow>> getStandardConsumption(
    DateTime start,
    DateTime end,
  ) async {
    final rows = await customSelect(
      'SELECT '
      '  i.id AS ingredient_id, '
      '  i.name AS ingredient_name, '
      '  i.unit_of_measurement AS unit, '
      '  SUM(ti.quantity * r.quantity_required) AS usage_amount '
      'FROM transaction_items ti '
      '  JOIN transactions t ON ti.transaction_id = t.id '
      '  JOIN recipes r ON r.meal_id = ti.meal_id '
      '  JOIN ingredients i ON i.id = r.ingredient_id '
      'WHERE t.type = \'sale\' '
      '  AND t.created_at >= ? AND t.created_at <= ? '
      'GROUP BY i.id',
      variables: [Variable<DateTime>(start), Variable<DateTime>(end)],
      readsFrom: {transactionItems, transactions, recipes, ingredients},
    ).get();

    return rows.map((row) => ConsumptionRow(
      ingredientId: row.read<int>('ingredient_id'),
      ingredientName: row.read<String>('ingredient_name'),
      unit: row.read<String>('unit'),
      usageAmount: row.read<double>('usage_amount'),
    )).toList();
  }

  /// Waste ingredient usage from waste transactions.
  Future<List<ConsumptionRow>> getWasteConsumption(
    DateTime start,
    DateTime end,
  ) async {
    final rows = await customSelect(
      'SELECT '
      '  i.id AS ingredient_id, '
      '  i.name AS ingredient_name, '
      '  i.unit_of_measurement AS unit, '
      '  SUM(ti.quantity) AS usage_amount '
      'FROM transaction_items ti '
      '  JOIN transactions t ON ti.transaction_id = t.id '
      '  JOIN ingredients i ON i.id = ti.ingredient_id '
      'WHERE t.type = \'waste\' '
      '  AND t.created_at >= ? AND t.created_at <= ? '
      'GROUP BY i.id',
      variables: [Variable<DateTime>(start), Variable<DateTime>(end)],
      readsFrom: {transactionItems, transactions, ingredients},
    ).get();

    return rows.map((row) => ConsumptionRow(
      ingredientId: row.read<int>('ingredient_id'),
      ingredientName: row.read<String>('ingredient_name'),
      unit: row.read<String>('unit'),
      usageAmount: row.read<double>('usage_amount'),
    )).toList();
  }

  // ── Report 4: Peak Hours Analysis ─────────────────────────

  /// Aggregates sales by hour of day for a given date range.
  ///
  /// Drift NativeDatabase stores DateTimeColumn as Unix epoch seconds,
  /// so we use `created_at` directly with strftime on the integer value.
  Future<List<PeakHourRow>> getPeakHoursAnalysis(
    DateTime start,
    DateTime end,
  ) async {
    final rows = await customSelect(
      'SELECT '
      '  CAST(strftime(\'%H\', created_at) AS INTEGER) AS hour_of_day, '
      '  COUNT(*) AS txn_count, '
      '  SUM(total_amount) AS total_revenue '
      'FROM transactions '
      'WHERE type = \'sale\' '
      '  AND created_at >= ? AND created_at <= ? '
      'GROUP BY hour_of_day '
      'ORDER BY hour_of_day',
      variables: [Variable<DateTime>(start), Variable<DateTime>(end)],
      readsFrom: {transactions},
    ).get();

    return rows.map((row) => PeakHourRow(
      hourOfDay: row.read<int>('hour_of_day'),
      transactionCount: row.read<int>('txn_count'),
      totalRevenue: row.read<double>('total_revenue'),
    )).toList();
  }

  // ── Report 5: Cashier Performance & Cash Variance ─────────

  /// Aggregates shift data per cashier for a given date range.
  Future<List<CashierPerformanceRow>> getCashierPerformance(
    DateTime start,
    DateTime end,
  ) async {
    final rows = await customSelect(
      'SELECT '
      '  u.id AS user_id, '
      '  u.username AS cashier_name, '
      '  COUNT(s.id) AS total_shifts, '
      '  COALESCE(SUM(s.total_sales), 0.0) AS total_sales, '
      '  COALESCE(SUM(CASE WHEN s.variance < 0 THEN 1 ELSE 0 END), 0) AS shortage_count, '
      '  COALESCE(SUM(CASE WHEN s.variance < 0 THEN ABS(s.variance) ELSE 0 END), 0.0) AS total_shortage, '
      '  COALESCE(SUM(CASE WHEN s.variance > 0 THEN s.variance ELSE 0 END), 0.0) AS total_surplus, '
      '  COALESCE(AVG(s.variance), 0.0) AS avg_variance '
      'FROM shifts s '
      '  JOIN users u ON s.cashier_id = u.id '
      'WHERE s.status = \'closed\' '
      '  AND s.opened_at >= ? AND s.opened_at <= ? '
      'GROUP BY u.id '
      'ORDER BY total_sales DESC',
      variables: [Variable<DateTime>(start), Variable<DateTime>(end)],
      readsFrom: {shifts, users},
    ).get();

    return rows.map((row) => CashierPerformanceRow(
      userId: row.read<int>('user_id'),
      cashierName: row.read<String>('cashier_name'),
      totalShifts: row.read<int>('total_shifts'),
      totalSales: row.read<double>('total_sales'),
      shortageCount: row.read<int>('shortage_count'),
      totalShortage: row.read<double>('total_shortage'),
      totalSurplus: row.read<double>('total_surplus'),
      avgVariance: row.read<double>('avg_variance'),
    )).toList();
  }
}

// ── DAO Row Data Classes ──────────────────────────────────────

/// Raw row from the Product Mix query.
class ProductMixRow {
  final int mealId;
  final String mealName;
  final String category;
  final double totalQty;
  final double totalRevenue;

  const ProductMixRow({
    required this.mealId,
    required this.mealName,
    required this.category,
    required this.totalQty,
    required this.totalRevenue,
  });
}

/// Raw row from the Expense Breakdown query.
class ExpenseBreakdownRow {
  final String category;
  final int entryCount;
  final double categoryTotal;

  const ExpenseBreakdownRow({
    required this.category,
    required this.entryCount,
    required this.categoryTotal,
  });
}

/// Raw row from the Consumption queries (both standard and waste).
class ConsumptionRow {
  final int ingredientId;
  final String ingredientName;
  final String unit;
  final double usageAmount;

  const ConsumptionRow({
    required this.ingredientId,
    required this.ingredientName,
    required this.unit,
    required this.usageAmount,
  });
}

/// Raw row from the Peak Hours query.
class PeakHourRow {
  final int hourOfDay;
  final int transactionCount;
  final double totalRevenue;

  const PeakHourRow({
    required this.hourOfDay,
    required this.transactionCount,
    required this.totalRevenue,
  });
}

/// Raw row from the Cashier Performance query.
class CashierPerformanceRow {
  final int userId;
  final String cashierName;
  final int totalShifts;
  final double totalSales;
  final int shortageCount;
  final double totalShortage;
  final double totalSurplus;
  final double avgVariance;

  const CashierPerformanceRow({
    required this.userId,
    required this.cashierName,
    required this.totalShifts,
    required this.totalSales,
    required this.shortageCount,
    required this.totalShortage,
    required this.totalSurplus,
    required this.avgVariance,
  });
}
