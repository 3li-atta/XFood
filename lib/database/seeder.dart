import 'package:drift/drift.dart';
import 'app_database.dart';
import '../core/utils/password_hasher.dart';

/// Seeds the database with initial data on first run.
///
/// Creates default users, ingredients, meals, and recipes if they do not exist.
class DatabaseSeeder {
  final AppDatabase _db;

  DatabaseSeeder(this._db);

  /// Run all seeders. Safe to call multiple times — idempotent.
  Future<void> seed() async {
    await _seedDefaultUsers();
    await _seedDefaultMenuAndInventory();
    await _seedDefaultTables();
  }

  /// Seed initial dine-in tables if none exist.
  Future<void> _seedDefaultTables() async {
    final existingTables = await _db.tableDao.getAllTables();
    if (existingTables.isEmpty) {
      for (int i = 1; i <= 8; i++) {
        await _db.tableDao.insertTable(
          TablesCompanion.insert(
            name: 'Table $i (طاولة $i)',
            seatsCount: const Value(4),
          ),
        );
      }
    }
  }

  /// Create default admin and cashier users if none exist.
  Future<void> _seedDefaultUsers() async {
    final existingUsers = await _db.userDao.getAllUsers();

    if (existingUsers.isEmpty) {
      final adminId = await _db.userDao.insertUser(UsersCompanion.insert(
        username: 'admin',
        passwordHash: PasswordHasher.hash('admin123'),
        recoveryEmail: 'admin@xfood.local',
        role: 'admin',
        mustChangePassword: const Value(true),
      ));

      await _db.userDao.assignPermissions(adminId, [
        'make_sales',
        'manage_shifts',
        'manage_inventory',
        'manage_meals',
        'view_transactions',
        'view_reports',
        'manage_purchases',
        'manage_treasury',
        'manage_backup',
        'void_refund_sale',
        'apply_large_discount',
        'manage_users'
      ]);

      // Also create a default cashier for quick testing
      final cashierId = await _db.userDao.insertUser(UsersCompanion.insert(
        username: 'cashier',
        passwordHash: PasswordHasher.hash('cashier123'),
        recoveryEmail: 'cashier@xfood.local',
        role: 'cashier',
        mustChangePassword: const Value(true),
      ));

      await _db.userDao.assignPermissions(cashierId, [
        'make_sales',
        'manage_shifts'
      ]);
    }
  }

  /// Seed initial ingredients, meals, and recipes.
  Future<void> _seedDefaultMenuAndInventory() async {
    final existingIngredients = await _db.ingredientDao.getAllIngredients();
    final existingMeals = await _db.mealDao.getAllMeals();

    if (existingIngredients.isEmpty && existingMeals.isEmpty) {
      // 1. Seed Ingredients
      final beefId = await _db.ingredientDao.insertIngredient(
        IngredientsCompanion.insert(
          name: 'Beef Patty',
          unitOfMeasurement: 'pieces',
          currentStock: const Value(50.0),
          costPrice: 1.50,
        ),
      );

      final bunId = await _db.ingredientDao.insertIngredient(
        IngredientsCompanion.insert(
          name: 'Burger Bun',
          unitOfMeasurement: 'pieces',
          currentStock: const Value(100.0),
          costPrice: 0.20,
        ),
      );

      final cheeseId = await _db.ingredientDao.insertIngredient(
        IngredientsCompanion.insert(
          name: 'Cheddar Cheese Slice',
          unitOfMeasurement: 'pieces',
          currentStock: const Value(80.0),
          costPrice: 0.30,
        ),
      );

      final lettuceId = await _db.ingredientDao.insertIngredient(
        IngredientsCompanion.insert(
          name: 'Lettuce',
          unitOfMeasurement: 'grams',
          currentStock: const Value(5000.0),
          costPrice: 0.005, // $5 per kg
        ),
      );

      final tomatoId = await _db.ingredientDao.insertIngredient(
        IngredientsCompanion.insert(
          name: 'Tomato',
          unitOfMeasurement: 'grams',
          currentStock: const Value(3000.0),
          costPrice: 0.004, // $4 per kg
        ),
      );

      final potatoId = await _db.ingredientDao.insertIngredient(
        IngredientsCompanion.insert(
          name: 'Potato',
          unitOfMeasurement: 'grams',
          currentStock: const Value(10000.0),
          costPrice: 0.002, // $2 per kg
        ),
      );

      final syrupId = await _db.ingredientDao.insertIngredient(
        IngredientsCompanion.insert(
          name: 'Cola Syrup',
          unitOfMeasurement: 'ml',
          currentStock: const Value(20000.0),
          costPrice: 0.005, // $5 per liter
        ),
      );

      // 2. Seed Meals
      final burgerId = await _db.mealDao.insertMeal(
        MealsCompanion.insert(
          name: 'Classic Beef Burger',
          sellingPrice: 8.99,
          category: 'Main Course',
        ),
      );

      final cheeseburgerId = await _db.mealDao.insertMeal(
        MealsCompanion.insert(
          name: 'Cheeseburger Deluxe',
          sellingPrice: 9.99,
          category: 'Main Course',
        ),
      );

      final friesId = await _db.mealDao.insertMeal(
        MealsCompanion.insert(
          name: 'Large French Fries',
          sellingPrice: 3.49,
          category: 'Side',
        ),
      );

      final colaId = await _db.mealDao.insertMeal(
        MealsCompanion.insert(
          name: 'Fountain Cola',
          sellingPrice: 1.99,
          category: 'Drink',
        ),
      );

      // 3. Seed Recipes
      // Classic Beef Burger Recipe: 1 Beef Patty, 1 Bun, 20g Lettuce, 30g Tomato
      await _db.recipeDao.addIngredientToRecipe(
        RecipesCompanion.insert(
          mealId: burgerId,
          ingredientId: beefId,
          quantityRequired: 1.0,
        ),
      );
      await _db.recipeDao.addIngredientToRecipe(
        RecipesCompanion.insert(
          mealId: burgerId,
          ingredientId: bunId,
          quantityRequired: 1.0,
        ),
      );
      await _db.recipeDao.addIngredientToRecipe(
        RecipesCompanion.insert(
          mealId: burgerId,
          ingredientId: lettuceId,
          quantityRequired: 20.0,
        ),
      );
      await _db.recipeDao.addIngredientToRecipe(
        RecipesCompanion.insert(
          mealId: burgerId,
          ingredientId: tomatoId,
          quantityRequired: 30.0,
        ),
      );

      // Cheeseburger Recipe: 1 Beef Patty, 1 Bun, 20g Lettuce, 30g Tomato, 1 Cheese Slice
      await _db.recipeDao.addIngredientToRecipe(
        RecipesCompanion.insert(
          mealId: cheeseburgerId,
          ingredientId: beefId,
          quantityRequired: 1.0,
        ),
      );
      await _db.recipeDao.addIngredientToRecipe(
        RecipesCompanion.insert(
          mealId: cheeseburgerId,
          ingredientId: bunId,
          quantityRequired: 1.0,
        ),
      );
      await _db.recipeDao.addIngredientToRecipe(
        RecipesCompanion.insert(
          mealId: cheeseburgerId,
          ingredientId: lettuceId,
          quantityRequired: 20.0,
        ),
      );
      await _db.recipeDao.addIngredientToRecipe(
        RecipesCompanion.insert(
          mealId: cheeseburgerId,
          ingredientId: tomatoId,
          quantityRequired: 30.0,
        ),
      );
      await _db.recipeDao.addIngredientToRecipe(
        RecipesCompanion.insert(
          mealId: cheeseburgerId,
          ingredientId: cheeseId,
          quantityRequired: 1.0,
        ),
      );

      // French Fries Recipe: 150g Potato
      await _db.recipeDao.addIngredientToRecipe(
        RecipesCompanion.insert(
          mealId: friesId,
          ingredientId: potatoId,
          quantityRequired: 150.0,
        ),
      );

      // Cola Recipe: 250ml Cola Syrup
      await _db.recipeDao.addIngredientToRecipe(
        RecipesCompanion.insert(
          mealId: colaId,
          ingredientId: syrupId,
          quantityRequired: 250.0,
        ),
      );
    }
  }
}
