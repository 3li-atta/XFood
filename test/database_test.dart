import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_test/flutter_test.dart';
import 'package:xfood_pos/database/app_database.dart';
import 'package:xfood_pos/database/daos/ingredient_dao.dart';
import 'package:xfood_pos/database/daos/meal_dao.dart';
import 'package:xfood_pos/database/daos/recipe_dao.dart';
import 'package:xfood_pos/database/daos/transaction_dao.dart';
import 'package:xfood_pos/database/daos/user_dao.dart';
import 'package:xfood_pos/database/daos/shift_dao.dart';
import 'package:xfood_pos/database/daos/purchase_dao.dart';
import 'package:xfood_pos/database/daos/treasury_dao.dart';
import 'package:xfood_pos/core/error/exceptions.dart';
import 'package:xfood_pos/features/shifts/data/repositories/shift_repository_impl.dart';

void main() {
  late AppDatabase db;
  late UserDao userDao;
  late IngredientDao ingredientDao;
  late MealDao mealDao;
  late RecipeDao recipeDao;
  late TransactionDao transactionDao;
  late ShiftDao shiftDao;
  late PurchaseDao purchaseDao;
  late TreasuryDao treasuryDao;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    userDao = UserDao(db);
    ingredientDao = IngredientDao(db);
    mealDao = MealDao(db);
    recipeDao = RecipeDao(db);
    transactionDao = TransactionDao(db);
    shiftDao = ShiftDao(db);
    purchaseDao = PurchaseDao(db);
    treasuryDao = TreasuryDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Inventory and Costing Tests (WAC)', () {
    test('should calculate WAC cost price on purchases correctly', () async {
      // 1. Seed user & ingredient
      final userId = await userDao.insertUser(const UsersCompanion(
        username: drift.Value('admin'),
        passwordHash: drift.Value('hash'),
        recoveryEmail: drift.Value('admin@local.net'),
        role: drift.Value('admin'),
      ));

      final ingId = await ingredientDao.insertIngredient(const IngredientsCompanion(
        name: drift.Value('Beef Patty'),
        unitOfMeasurement: drift.Value('pcs'),
        currentStock: drift.Value(10.0),
        costPrice: drift.Value(2.0), // 10 pcs @ $2.00 each
      ));

      // 2. Open a Shift
      final shiftId = await shiftDao.openShift(cashierId: userId, startingCash: 500.0);

      // 3. Purchase 10 more @ $4.00 each
      // Expected stock: 10 + 10 = 20
      // Expected cost price WAC: (10 * 2.00 + 10 * 4.00) / 20 = $3.00
      await purchaseDao.createPurchaseInvoice(
        userId: userId,
        shiftId: shiftId,
        supplierName: 'Vendor A',
        notes: 'Restock',
        items: [
          PurchaseItemInput(
            ingredientId: ingId,
            quantity: 10.0,
            unitCost: 4.0,
          ),
        ],
      );

      final updatedIngredient = await ingredientDao.getById(ingId);
      expect(updatedIngredient.currentStock, 20.0);
      expect(updatedIngredient.costPrice, 3.0);

      // Verify Shift totalPurchases updated
      final shift = await shiftDao.getById(shiftId);
      expect(shift.totalPurchases, 40.0);

      // 4. Verify Treasury transaction exists
      final balance = await treasuryDao.getCurrentBalance();
      // starting cash 500 - purchase 40 = 460
      expect(balance, 460.0);
    });
  });

  group('Shift Gate and Treasury Tests', () {
    test('should reject sales if cashier does not have active shift', () async {
      final userId = await userDao.insertUser(const UsersCompanion(
        username: drift.Value('cashier'),
        passwordHash: drift.Value('hash'),
        recoveryEmail: drift.Value('cashier@local.net'),
        role: drift.Value('cashier'),
      ));

      final mealId = await mealDao.insertMeal(const MealsCompanion(
        name: drift.Value('Burger'),
        sellingPrice: drift.Value(10.0),
        category: drift.Value('Main'),
      ));

      // Attempt sale without active shift -> should throw exception
      expect(
        () => transactionDao.createSaleWithStockDeduction(
          userId: userId,
          shiftId: null,
          notes: null,
          lineItems: [
            SaleLineItem(mealId: mealId, quantity: 1, priceAtTime: 10.0),
          ],
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('should complete sales, record income and update shift totals', () async {
      final userId = await userDao.insertUser(const UsersCompanion(
        username: drift.Value('cashier'),
        passwordHash: drift.Value('hash'),
        recoveryEmail: drift.Value('cashier@local.net'),
        role: drift.Value('cashier'),
      ));

      final mealId = await mealDao.insertMeal(const MealsCompanion(
        name: drift.Value('Burger'),
        sellingPrice: drift.Value(10.0),
        category: drift.Value('Main'),
      ));

      // Open shift
      final shiftId = await shiftDao.openShift(cashierId: userId, startingCash: 100.0);

      // Perform sale
      await transactionDao.createSaleWithStockDeduction(
        userId: userId,
        shiftId: shiftId,
        notes: 'First sale',
        lineItems: [
          SaleLineItem(mealId: mealId, quantity: 2, priceAtTime: 10.0), // Total $20.0
        ],
      );

      // Check treasury balance: 100 opening + 20 sale = 120
      final balance = await treasuryDao.getCurrentBalance();
      expect(balance, 120.0);

      // Check shift totals
      final shift = await shiftDao.getById(shiftId);
      expect(shift.totalSales, 20.0);

      // Close shift with actual 120.0 -> variance should be 0
      await shiftDao.closeShift(shiftId: shiftId, actualClosingCash: 120.0, notes: 'Perfect match');
      final closedShift = await shiftDao.getById(shiftId);
      expect(closedShift.status, 'closed');
      expect(closedShift.variance, 0.0);
    });

    test('should fallback to active cashier shift when queried for an Admin user', () async {
      final adminId = await userDao.insertUser(const UsersCompanion(
        username: drift.Value('admin'),
        passwordHash: drift.Value('admin_hash'),
        recoveryEmail: drift.Value('admin@local.net'),
        role: drift.Value('admin'),
      ));

      final cashierId = await userDao.insertUser(const UsersCompanion(
        username: drift.Value('cashier'),
        passwordHash: drift.Value('cashier_hash'),
        recoveryEmail: drift.Value('cashier@local.net'),
        role: drift.Value('cashier'),
      ));

      // Open shift for cashier
      final cashierShiftId = await shiftDao.openShift(cashierId: cashierId, startingCash: 200.0);

      // Query getActiveShift for cashier -> should return cashier's shift
      final cashierShift = await shiftDao.getActiveShift(cashierId);
      expect(cashierShift, isNotNull);
      expect(cashierShift!.id, cashierShiftId);

      // Query getActiveShift for admin -> should return null at DAO level since shift is owned by cashier
      final adminShiftDao = await shiftDao.getActiveShift(adminId);
      expect(adminShiftDao, isNull);

      // Query getActiveShift via repository for admin -> should fallback to cashier's open shift
      final shiftRepo = ShiftRepositoryImpl(shiftDao, userDao);
      final adminShiftRepo = await shiftRepo.getActiveShift(adminId);
      expect(adminShiftRepo, isNotNull);
      expect(adminShiftRepo!.id, cashierShiftId);
      expect(adminShiftRepo.cashierId, cashierId);
    });
  });

  group('Security and User Authentication Tests (V-12)', () {
    test('should require default seeded users to change password on first login', () async {
      final userId = await userDao.insertUser(const UsersCompanion(
        username: drift.Value('temp_user'),
        passwordHash: drift.Value('old_hash'),
        recoveryEmail: drift.Value('temp@local.net'),
        role: drift.Value('cashier'),
        mustChangePassword: drift.Value(true),
      ));

      final user = (await userDao.getAllUsers()).firstWhere((u) => u.id == userId);
      expect(user.mustChangePassword, isTrue);

      final success = await userDao.updatePasswordAndClearForceFlag(userId, 'new_hashed_password');
      expect(success, isTrue);

      final updatedUser = (await userDao.getAllUsers()).firstWhere((u) => u.id == userId);
      expect(updatedUser.mustChangePassword, isFalse);
      expect(updatedUser.passwordHash, 'new_hashed_password');
    });
  });

  group('RBAC and Granular Permissions Tests', () {
    test('should assign and fetch user permissions correctly', () async {
      final userId = await userDao.insertUser(const UsersCompanion(
        username: drift.Value('test_cashier'),
        passwordHash: drift.Value('hash'),
        recoveryEmail: drift.Value('cashier@local.net'),
        role: drift.Value('cashier'),
      ));

      // Fetch permissions initially -> should be empty
      final initialPermissions = await userDao.getPermissionsForUser(userId);
      expect(initialPermissions, isEmpty);

      // Assign permissions
      final assigned = ['make_sales', 'manage_shifts'];
      await userDao.assignPermissions(userId, assigned);

      // Fetch again -> should match
      final updated = await userDao.getPermissionsForUser(userId);
      expect(updated, containsAll(assigned));
      expect(updated.length, 2);

      // Replace permissions
      final replacement = ['make_sales', 'void_refund_sale'];
      await userDao.assignPermissions(userId, replacement);

      final finalPerms = await userDao.getPermissionsForUser(userId);
      expect(finalPerms, containsAll(replacement));
      expect(finalPerms.contains('manage_shifts'), isFalse);
      expect(finalPerms.length, 2);
    });
  });
}
