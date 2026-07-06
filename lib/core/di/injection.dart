import 'package:get_it/get_it.dart';
import 'package:xfood_pos/database/app_database.dart';
import 'package:xfood_pos/features/backup/domain/services/backup_service.dart';
import 'package:xfood_pos/features/backup/data/services/google_drive_backup_service.dart';
import 'package:xfood_pos/core/services/device_config_service.dart';
import 'package:xfood_pos/core/services/lan_server_service.dart';
import 'package:xfood_pos/core/services/lan_sync/websocket_hub.dart';
import 'package:xfood_pos/core/services/lan_sync/api_handlers.dart';
import 'package:xfood_pos/core/services/lan_sync/api_router.dart';
import 'package:xfood_pos/core/services/lan_sync/lan_client_service.dart';
import 'package:xfood_pos/features/meals/data/repositories/remote_meal_repository.dart';
import 'package:xfood_pos/features/transactions/data/repositories/remote_transaction_repository.dart';
import 'package:xfood_pos/features/shifts/data/repositories/remote_shift_repository.dart';
import 'package:xfood_pos/features/reports/domain/repositories/reports_repository.dart';
import 'package:xfood_pos/features/reports/data/repositories/reports_repository_impl.dart';
import 'package:xfood_pos/features/reports/domain/usecases/report_usecases.dart';
import 'package:xfood_pos/features/reports/presentation/bloc/reports_bloc.dart';

// Repositories
import 'package:xfood_pos/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:xfood_pos/features/auth/domain/repositories/auth_repository.dart';
import 'package:xfood_pos/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:xfood_pos/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:xfood_pos/features/meals/data/repositories/meal_repository_impl.dart';
import 'package:xfood_pos/features/meals/domain/repositories/meal_repository.dart';
import 'package:xfood_pos/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:xfood_pos/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:xfood_pos/features/procurement/domain/repositories/purchase_repository.dart';
import 'package:xfood_pos/features/procurement/data/repositories/purchase_repository_impl.dart';
import 'package:xfood_pos/features/treasury/data/repositories/treasury_repository_impl.dart';
import 'package:xfood_pos/features/treasury/domain/repositories/treasury_repository.dart';
import 'package:xfood_pos/features/shifts/domain/repositories/shift_repository.dart';
import 'package:xfood_pos/features/shifts/data/repositories/shift_repository_impl.dart';
import 'package:xfood_pos/features/expenses/domain/repositories/expense_repository.dart';
import 'package:xfood_pos/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:xfood_pos/features/expenses/domain/usecases/expense_usecases.dart';
import 'package:xfood_pos/features/expenses/presentation/bloc/expense_bloc.dart';

// Use Cases
import 'package:xfood_pos/features/auth/domain/usecases/login_usecase.dart';
import 'package:xfood_pos/features/auth/domain/usecases/recover_password_usecase.dart';
import 'package:xfood_pos/features/transactions/domain/usecases/create_sale_usecase.dart';
import 'package:xfood_pos/features/transactions/domain/usecases/record_waste_usecase.dart';
import 'package:xfood_pos/features/transactions/domain/usecases/get_profit_loss_usecase.dart';
import 'package:xfood_pos/features/procurement/domain/usecases/procurement_usecases.dart';
import 'package:xfood_pos/features/treasury/domain/usecases/treasury_usecases.dart';
import 'package:xfood_pos/features/shifts/domain/usecases/shift_usecases.dart';

// Blocs
import 'package:xfood_pos/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:xfood_pos/features/transactions/presentation/bloc/pos_bloc.dart';
import 'package:xfood_pos/features/transactions/presentation/bloc/profit_loss_bloc.dart';
import 'package:xfood_pos/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:xfood_pos/features/meals/presentation/bloc/meals_bloc.dart';
import 'package:xfood_pos/features/procurement/presentation/bloc/purchase_bloc.dart';
import 'package:xfood_pos/features/treasury/presentation/bloc/treasury_bloc.dart';
import 'package:xfood_pos/features/shifts/presentation/bloc/shift_bloc.dart';
import 'package:xfood_pos/features/backup/presentation/bloc/backup_bloc.dart';
import 'package:xfood_pos/features/settings/presentation/bloc/device_settings_bloc.dart';

final getIt = GetIt.instance;

/// Initialize all dependency injection bindings.
Future<void> configureDependencies() async {
  // Prevent duplicate registration on hot restart / WorkManager callback.
  if (getIt.isRegistered<AppDatabase>()) return;

  // ── Database ──────────────────────────────────────────────
  final database = AppDatabase();
  getIt.registerSingleton<AppDatabase>(database);

  // ── LAN Sync & Device Config ──────────────────────────────
  final deviceConfig = DeviceConfigService();
  await deviceConfig.init();
  getIt.registerSingleton<DeviceConfigService>(deviceConfig);

  final webSocketHub = WebSocketHub(deviceConfig);
  getIt.registerSingleton<WebSocketHub>(webSocketHub);

  final lanServer = LanServerService(webSocketHub);
  getIt.registerSingleton<LanServerService>(lanServer);

  final lanClient = LanClientService(deviceConfig);
  getIt.registerSingleton<LanClientService>(lanClient);

  // ── DAOs ──────────────────────────────────────────────────
  getIt.registerLazySingleton(() => database.userDao);
  getIt.registerLazySingleton(() => database.ingredientDao);
  getIt.registerLazySingleton(() => database.mealDao);
  getIt.registerLazySingleton(() => database.recipeDao);
  getIt.registerLazySingleton(() => database.transactionDao);
  getIt.registerLazySingleton(() => database.shiftDao);
  getIt.registerLazySingleton(() => database.purchaseDao);
  getIt.registerLazySingleton(() => database.treasuryDao);
  getIt.registerLazySingleton(() => database.expenseDao);
  getIt.registerLazySingleton(() => database.auditLogDao);
  getIt.registerLazySingleton(() => database.tableDao);
  getIt.registerLazySingleton(() => database.pendingOrderDao);
  getIt.registerLazySingleton(() => database.reportsDao);

  // ── LAN Sync Handlers & Router ───────────────────────────
  getIt.registerLazySingleton<ApiHandlers>(() => ApiHandlers(
    mealDao: getIt(),
    tableDao: getIt(),
    pendingOrderDao: getIt(),
    transactionDao: getIt(),
    shiftDao: getIt(),
    deviceConfig: getIt(),
    webSocketHub: getIt(),
  ));
  getIt.registerLazySingleton<ApiRouter>(() => ApiRouter(getIt()));

  // ── Repositories ──────────────────────────────────────────
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<InventoryRepository>(
    () => InventoryRepositoryImpl(getIt()),
  );
  _registerRepos(deviceConfig.isMaster);

  getIt.registerLazySingleton<PurchaseRepository>(
    () => PurchaseRepositoryImpl(getIt(), getIt()),
  );
  getIt.registerLazySingleton<TreasuryRepository>(
    () => TreasuryRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<BackupService>(
    () => GoogleDriveBackupService(),
  );
  getIt.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<ReportsRepository>(
    () => ReportsRepositoryImpl(getIt()),
  );

  // ── Use Cases ─────────────────────────────────────────────
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => RecoverPasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => CreateSaleUseCase(getIt()));
  getIt.registerLazySingleton(() => GetTransactionsUseCase(getIt()));
  getIt.registerLazySingleton(() => RecordWasteUseCase(getIt()));
  getIt.registerLazySingleton(() => GetProfitLossUseCase(getIt()));
  
  getIt.registerLazySingleton(() => CreatePurchaseInvoiceUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAllPurchaseInvoicesUseCase(getIt()));
  getIt.registerLazySingleton(() => VoidPurchaseInvoiceUseCase(getIt()));
  
  getIt.registerLazySingleton(() => GetCurrentBalanceUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAllTreasuryTransactionsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetTreasuryTransactionsPaginatedUseCase(getIt()));
  getIt.registerLazySingleton(() => AddManualAdjustmentUseCase(getIt()));
  
  getIt.registerLazySingleton(() => OpenShiftUseCase(getIt()));
  getIt.registerLazySingleton(() => CloseShiftUseCase(getIt()));
  getIt.registerLazySingleton(() => GetActiveShiftUseCase(getIt()));
  getIt.registerLazySingleton(() => GetShiftHistoryUseCase(getIt()));
  getIt.registerLazySingleton(() => RecordExpenseUseCase(getIt()));
  getIt.registerLazySingleton(() => GetExpensesUseCase(getIt()));

  // Reports Use Cases
  getIt.registerLazySingleton(() => GetProductMixUseCase(getIt()));
  getIt.registerLazySingleton(() => GetExpenseBreakdownUseCase(getIt()));
  getIt.registerLazySingleton(() => GetInventoryConsumptionUseCase(getIt()));
  getIt.registerLazySingleton(() => GetPeakHoursUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCashierPerformanceUseCase(getIt()));

  // ── Blocs ─────────────────────────────────────────────────
  getIt.registerFactory(() => AuthBloc(
        loginUseCase: getIt(),
        recoverPasswordUseCase: getIt(),
      ));
  getIt.registerFactory(() => PosBloc(
        createSaleUseCase: getIt(),
        shiftRepository: getIt(),
      ));
  getIt.registerFactory(() => ProfitLossBloc(
        getProfitLossUseCase: getIt(),
      ));
  getIt.registerFactory(() => InventoryBloc(
        repository: getIt(),
      ));
  getIt.registerFactory(() => MealsBloc(
        repository: getIt(),
      ));
  getIt.registerFactory(() => PurchaseBloc(
        createPurchaseInvoiceUseCase: getIt(),
        getAllPurchaseInvoicesUseCase: getIt(),
        voidPurchaseInvoiceUseCase: getIt(),
      ));
  getIt.registerFactory(() => TreasuryBloc(
        getCurrentBalanceUseCase: getIt(),
        getTreasuryTransactionsPaginatedUseCase: getIt(),
        addManualAdjustmentUseCase: getIt(),
      ));
  getIt.registerFactory(() => ShiftBloc(
        openShiftUseCase: getIt(),
        closeShiftUseCase: getIt(),
        getActiveShiftUseCase: getIt(),
        getShiftHistoryUseCase: getIt(),
      ));
  getIt.registerFactory(() => BackupBloc(getIt()));
  getIt.registerFactory(() => ExpenseBloc(
        recordExpenseUseCase: getIt(),
        getExpensesUseCase: getIt(),
      ));
  getIt.registerFactory(() => DeviceSettingsBloc(
        config: getIt(),
        server: getIt(),
        client: getIt(),
        apiRouter: getIt(),
        webSocketHub: getIt(),
      ));
  getIt.registerFactory(() => ReportsBloc(
        getProductMixUseCase: getIt(),
        getExpenseBreakdownUseCase: getIt(),
        getInventoryConsumptionUseCase: getIt(),
        getPeakHoursUseCase: getIt(),
        getCashierPerformanceUseCase: getIt(),
        getExpensesUseCase: getIt(),
        getProfitLossUseCase: getIt(),
      ));
}

void _registerRepos(bool isMaster) {
  if (isMaster) {
    getIt.registerLazySingleton<MealRepository>(
      () => MealRepositoryImpl(getIt(), getIt()),
    );
    getIt.registerLazySingleton<TransactionRepository>(
      () => TransactionRepositoryImpl(getIt(), getIt(), getIt()),
    );
    getIt.registerLazySingleton<ShiftRepository>(
      () => ShiftRepositoryImpl(getIt(), getIt()),
    );
  } else {
    getIt.registerLazySingleton<MealRepository>(
      () => RemoteMealRepository(getIt()),
    );
    getIt.registerLazySingleton<TransactionRepository>(
      () => RemoteTransactionRepository(getIt()),
    );
    getIt.registerLazySingleton<ShiftRepository>(
      () => RemoteShiftRepository(getIt()),
    );
  }
}

void rebindRepositories() {
  final deviceConfig = getIt<DeviceConfigService>();
  final isMaster = deviceConfig.isMaster;

  if (getIt.isRegistered<MealRepository>()) {
    getIt.unregister<MealRepository>();
  }
  if (getIt.isRegistered<TransactionRepository>()) {
    getIt.unregister<TransactionRepository>();
  }
  if (getIt.isRegistered<ShiftRepository>()) {
    getIt.unregister<ShiftRepository>();
  }

  _registerRepos(isMaster);
}
