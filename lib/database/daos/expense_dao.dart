import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/expenses_table.dart';

part 'expense_dao.g.dart';

@DriftAccessor(tables: [Expenses])
class ExpenseDao extends DatabaseAccessor<AppDatabase> with _$ExpenseDaoMixin {
  ExpenseDao(super.db);

  Future<int> insertExpense(ExpensesCompanion companion) {
    return into(expenses).insert(companion);
  }

  Future<List<Expense>> getAllExpenses() {
    return (select(expenses)..orderBy([(e) => OrderingTerm.desc(e.date)])).get();
  }

  Future<List<Expense>> getAllExpensesPaginated(int limit, int offset) {
    return (select(expenses)
          ..orderBy([(e) => OrderingTerm.desc(e.date)])
          ..limit(limit, offset: offset))
        .get();
  }

  Future<Expense?> getExpenseById(int id) {
    return (select(expenses)..where((e) => e.id.equals(id))).getSingleOrNull();
  }

  Future<List<Expense>> getExpensesForDateRange(DateTime start, DateTime end) {
    return (select(expenses)
          ..where((e) => e.date.isBetweenValues(start, end))
          ..orderBy([(e) => OrderingTerm.desc(e.date)]))
        .get();
  }

  Future<double> getTotalExpensesForDateRange(DateTime start, DateTime end) async {
    final query = select(expenses)
      ..where((e) => e.date.isBetweenValues(start, end));
    final list = await query.get();
    return list.fold<double>(0.0, (sum, e) => sum + e.amount);
  }
}
