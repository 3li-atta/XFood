import 'package:get_it/get_it.dart';
import 'package:xfood_pos/database/app_database.dart';
import 'package:xfood_pos/features/backup/domain/services/backup_service.dart';
import 'package:xfood_pos/features/backup/data/services/google_drive_backup_service.dart';

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
import 'package:xfood_pos/features/treasury/domain/repositories/treasury_repository.dart';
import 'package:xfood_pos/features/treasury/data/repositories/treasury_repository_impl.dart';
import 'package:xfood_pos/features/shifts/domain/repositories/shift_repository.dart';
import 'package:xfood_pos/features/shifts/data/repositories/shift_repository_impl.dart';

// Use Cases
import 'package:xfood_pos/features/auth/domain/usecases/login_usecase.dart';
import 'package:xfood_pos/features/auth/domain/usecases/recover_password_usecase.dart';
import 'package:xfood_pos/features/transactions/domain/usecases/create_sale_usecase.dart';
import 'package:xfood_pos/features/procurement/domain/usecases/procurement_usecases.dart';
import 'package:xfood_pos/features/treasury/domain/usecases/treasury_usecases.dart';
import 'package:xfood_pos/features/shifts/domain/usecases/shift_usecases.dart';

// Blocs
import 'package:xfood_pos/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:xfood_pos/features/transactions/presentation/bloc/pos_bloc.dart';
import 'package:xfood_pos/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:xfood_pos/features/meals/presentation/bloc/meals_bloc.dart';
import 'package:xfood_pos/features/procurement/presentation/bloc/purchase_bloc.dart';
import 'package:xfood_pos/features/treasury/presentation/bloc/treasury_bloc.dart';
import 'package:xfood_pos/features/shifts/presentation/bloc/shift_bloc.dart';
import 'package:xfood_pos/features/backup/presentation/bloc/backup_bloc.dart';

final getIt = GetIt.instance;

/// Initialize all dependency injection bindings.
Future<void> configureDependencies() async {
  // ── Database ──────────────────────────────────────────────
  final database = AppDatabase();
  getIt.registerSingleton<AppDatabase>(database);

  // ── DAOs ──────────────────────────────────────────────────
  getIt.registerLazySingleton(() => database.userDao);
  getIt.registerLazySingleton(() => database.ingredientDao);
  getIt.registerLazySingleton(() => database.mealDao);
  getIt.registerLazySingleton(() => database.recipeDao);
  getIt.registerLazySingleton(() => database.transactionDao);
  getIt.registerLazySingleton(() => database.shiftDao);
  getIt.registerLazySingleton(() => database.purchaseDao);
  getIt.registerLazySingleton(() => database.treasuryDao);

  // ── Repositories ──────────────────────────────────────────
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<InventoryRepository>(
    () => InventoryRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<MealRepository>(
    () => MealRepositoryImpl(getIt(), getIt()),
  );
  getIt.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(getIt(), getIt()),
  );
  getIt.registerLazySingleton<PurchaseRepository>(
    () => PurchaseRepositoryImpl(getIt(), getIt()),
  );
  getIt.registerLazySingleton<TreasuryRepository>(
    () => TreasuryRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<ShiftRepository>(
    () => ShiftRepositoryImpl(getIt(), getIt()),
  );
  getIt.registerLazySingleton<BackupService>(
    () => GoogleDriveBackupService(),
  );

  // ── Use Cases ─────────────────────────────────────────────
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => RecoverPasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => CreateSaleUseCase(getIt()));
  getIt.registerLazySingleton(() => GetTransactionsUseCase(getIt()));
  
  getIt.registerLazySingleton(() => CreatePurchaseInvoiceUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAllPurchaseInvoicesUseCase(getIt()));
  getIt.registerLazySingleton(() => VoidPurchaseInvoiceUseCase(getIt()));
  
  getIt.registerLazySingleton(() => GetCurrentBalanceUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAllTreasuryTransactionsUseCase(getIt()));
  getIt.registerLazySingleton(() => AddManualAdjustmentUseCase(getIt()));
  
  getIt.registerLazySingleton(() => OpenShiftUseCase(getIt()));
  getIt.registerLazySingleton(() => CloseShiftUseCase(getIt()));
  getIt.registerLazySingleton(() => GetActiveShiftUseCase(getIt()));
  getIt.registerLazySingleton(() => GetShiftHistoryUseCase(getIt()));

  // ── Blocs ─────────────────────────────────────────────────
  getIt.registerLazySingleton(() => AuthBloc(
        loginUseCase: getIt(),
        recoverPasswordUseCase: getIt(),
      ));
  getIt.registerFactory(() => PosBloc(
        createSaleUseCase: getIt(),
        shiftRepository: getIt(),
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
        getAllTreasuryTransactionsUseCase: getIt(),
        addManualAdjustmentUseCase: getIt(),
      ));
  getIt.registerFactory(() => ShiftBloc(
        openShiftUseCase: getIt(),
        closeShiftUseCase: getIt(),
        getActiveShiftUseCase: getIt(),
        getShiftHistoryUseCase: getIt(),
      ));
  getIt.registerFactory(() => BackupBloc(getIt()));
}
