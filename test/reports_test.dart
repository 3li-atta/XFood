import 'package:bloc_test/bloc_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_test/flutter_test.dart';
import 'package:xfood_pos/database/app_database.dart';
import 'package:xfood_pos/database/daos/reports_dao.dart';
import 'package:xfood_pos/database/daos/user_dao.dart';
import 'package:xfood_pos/database/daos/ingredient_dao.dart';
import 'package:xfood_pos/database/daos/meal_dao.dart';
import 'package:xfood_pos/database/daos/recipe_dao.dart';
import 'package:xfood_pos/database/daos/transaction_dao.dart';
import 'package:xfood_pos/database/daos/shift_dao.dart';
import 'package:xfood_pos/database/daos/expense_dao.dart';
import 'package:xfood_pos/features/reports/data/repositories/reports_repository_impl.dart';
import 'package:xfood_pos/features/reports/domain/usecases/report_usecases.dart';
import 'package:xfood_pos/features/reports/presentation/bloc/reports_bloc.dart';
import 'package:xfood_pos/features/reports/presentation/bloc/reports_event.dart';
import 'package:xfood_pos/features/reports/presentation/bloc/reports_state.dart';
import 'package:xfood_pos/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:xfood_pos/features/expenses/domain/usecases/expense_usecases.dart';
import 'package:xfood_pos/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:xfood_pos/features/transactions/domain/usecases/get_profit_loss_usecase.dart';

void main() {
  late AppDatabase db;
  late ReportsDao reportsDao;
  late UserDao userDao;
  late MealDao mealDao;
  late TransactionDao transactionDao;
  late ShiftDao shiftDao;
  late ExpenseDao expenseDao;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    reportsDao = ReportsDao(db);
    userDao = UserDao(db);
    mealDao = MealDao(db);
    transactionDao = TransactionDao(db);
    shiftDao = ShiftDao(db);
    expenseDao = ExpenseDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Reports DAO Queries tests', () {
    test('should aggregate product mix report correctly', () async {
      // 1. Seed user, meal
      final userId = await userDao.insertUser(const UsersCompanion(
        username: drift.Value('test_user'),
        passwordHash: drift.Value('pass'),
        recoveryEmail: drift.Value('test@test.com'),
        role: drift.Value('admin'),
      ));

      final mealId = await mealDao.insertMeal(const MealsCompanion(
        name: drift.Value('Shawarma'),
        sellingPrice: drift.Value(15.0),
        category: drift.Value('Sandwiches'),
      ));

      // 2. Open shift and record a sale
      final shiftId = await shiftDao.openShift(cashierId: userId, startingCash: 200.0);
      await transactionDao.createSaleWithStockDeduction(
        userId: userId,
        shiftId: shiftId,
        notes: 'Test sale',
        lineItems: [
          SaleLineItem(mealId: mealId, quantity: 3.0, priceAtTime: 15.0),
        ],
      );

      final start = DateTime.now().subtract(const Duration(days: 1));
      final end = DateTime.now().add(const Duration(days: 1));

      // 3. Query report
      final report = await reportsDao.getProductMixReport(start, end);
      expect(report.length, 1);
      expect(report.first.mealName, 'Shawarma');
      expect(report.first.totalQty, 3.0);
      expect(report.first.totalRevenue, 45.0);
    });

    test('should aggregate operating expenses correctly', () async {
      final start = DateTime.now().subtract(const Duration(hours: 1));
      final end = DateTime.now().add(const Duration(hours: 1));

      await expenseDao.insertExpense(ExpensesCompanion(
        amount: const drift.Value(150.0),
        category: const drift.Value('Rent'),
        date: drift.Value(DateTime.now()),
      ));
      await expenseDao.insertExpense(ExpensesCompanion(
        amount: const drift.Value(50.0),
        category: const drift.Value('Rent'),
        date: drift.Value(DateTime.now()),
      ));
      await expenseDao.insertExpense(ExpensesCompanion(
        amount: const drift.Value(100.0),
        category: const drift.Value('Utilities'),
        date: drift.Value(DateTime.now()),
      ));

      final breakdown = await reportsDao.getExpenseBreakdown(start, end);
      expect(breakdown.length, 2);
      
      final rentRow = breakdown.firstWhere((r) => r.category == 'Rent');
      expect(rentRow.categoryTotal, 200.0);
      expect(rentRow.entryCount, 2);

      final utilitiesRow = breakdown.firstWhere((r) => r.category == 'Utilities');
      expect(utilitiesRow.categoryTotal, 100.0);
      expect(utilitiesRow.entryCount, 1);
    });
  });

  group('ReportsBloc Tests', () {
    late ReportsRepositoryImpl repository;
    late GetProductMixUseCase getProductMixUseCase;
    late GetExpenseBreakdownUseCase getExpenseBreakdownUseCase;
    late GetInventoryConsumptionUseCase getInventoryConsumptionUseCase;
    late GetPeakHoursUseCase getPeakHoursUseCase;
    late GetCashierPerformanceUseCase getCashierPerformanceUseCase;
    late GetExpensesUseCase getExpensesUseCase;
    late GetProfitLossUseCase getProfitLossUseCase;

    setUp(() {
      repository = ReportsRepositoryImpl(reportsDao);
      getProductMixUseCase = GetProductMixUseCase(repository);
      getExpenseBreakdownUseCase = GetExpenseBreakdownUseCase(repository);
      getInventoryConsumptionUseCase = GetInventoryConsumptionUseCase(repository);
      getPeakHoursUseCase = GetPeakHoursUseCase(repository);
      getCashierPerformanceUseCase = GetCashierPerformanceUseCase(repository);

      final expenseRepo = ExpenseRepositoryImpl(db);
      getExpensesUseCase = GetExpensesUseCase(expenseRepo);

      final txnRepo = TransactionRepositoryImpl(db.transactionDao, db.purchaseDao, db.expenseDao);
      getProfitLossUseCase = GetProfitLossUseCase(txnRepo);
    });

    blocTest<ReportsBloc, ReportsState>(
      'should emit ReportsLoading and then ReportsLoaded when LoadAllReportsEvent is added',
      build: () => ReportsBloc(
        getProductMixUseCase: getProductMixUseCase,
        getExpenseBreakdownUseCase: getExpenseBreakdownUseCase,
        getInventoryConsumptionUseCase: getInventoryConsumptionUseCase,
        getPeakHoursUseCase: getPeakHoursUseCase,
        getCashierPerformanceUseCase: getCashierPerformanceUseCase,
        getExpensesUseCase: getExpensesUseCase,
        getProfitLossUseCase: getProfitLossUseCase,
      ),
      act: (bloc) => bloc.add(LoadAllReportsEvent(
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now(),
      )),
      expect: () => [
        isA<ReportsLoading>(),
        isA<ReportsLoaded>(),
      ],
    );
  });
}
