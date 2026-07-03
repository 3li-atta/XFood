import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/meals_table.dart';

part 'meal_dao.g.dart';

/// Data Access Object for meal / menu item operations.
@DriftAccessor(tables: [Meals])
class MealDao extends DatabaseAccessor<AppDatabase> with _$MealDaoMixin {
  MealDao(super.db);

  /// Get all active meals, ordered by category then name.
  Future<List<Meal>> getActiveMeals() {
    return (select(meals)
          ..where((m) => m.isActive.equals(true))
          ..orderBy([
            (m) => OrderingTerm.asc(m.category),
            (m) => OrderingTerm.asc(m.name),
          ]))
        .get();
  }

  /// Get all meals (including inactive), ordered by name.
  Future<List<Meal>> getAllMeals() {
    return (select(meals)..orderBy([(m) => OrderingTerm.asc(m.name)])).get();
  }

  /// Get a single meal by id.
  Future<Meal> getById(int id) {
    return (select(meals)..where((m) => m.id.equals(id))).getSingle();
  }

  /// Watch active meals (reactive stream for POS UI).
  Stream<List<Meal>> watchActiveMeals() {
    return (select(meals)
          ..where((m) => m.isActive.equals(true))
          ..orderBy([
            (m) => OrderingTerm.asc(m.category),
            (m) => OrderingTerm.asc(m.name),
          ]))
        .watch();
  }

  /// Watch all meals (including inactive).
  Stream<List<Meal>> watchAllMeals() {
    return (select(meals)
          ..orderBy([
            (m) => OrderingTerm.asc(m.category),
            (m) => OrderingTerm.asc(m.name),
          ]))
        .watch();
  }

  /// Get meals filtered by category.
  Future<List<Meal>> getMealsByCategory(String category) {
    return (select(meals)
          ..where(
              (m) => m.category.equals(category) & m.isActive.equals(true))
          ..orderBy([(m) => OrderingTerm.asc(m.name)]))
        .get();
  }

  /// Insert a new meal. Returns the auto-generated id.
  Future<int> insertMeal(MealsCompanion meal) {
    return into(meals).insert(meal);
  }

  /// Update meal details.
  Future<bool> updateMeal(int mealId, MealsCompanion companion) {
    return (update(meals)..where((m) => m.id.equals(mealId)))
        .write(companion)
        .then((rows) => rows > 0);
  }

  /// Soft-delete a meal (set isActive = false).
  Future<bool> deactivateMeal(int mealId) {
    return (update(meals)..where((m) => m.id.equals(mealId)))
        .write(MealsCompanion(
          isActive: const Value(false),
          updatedAt: Value(DateTime.now()),
        ))
        .then((rows) => rows > 0);
  }

  /// Toggle active state of a meal.
  Future<bool> toggleMealActive(int mealId, bool isActive) {
    return (update(meals)..where((m) => m.id.equals(mealId)))
        .write(MealsCompanion(
          isActive: Value(isActive),
          updatedAt: Value(DateTime.now()),
        ))
        .then((rows) => rows > 0);
  }

  /// Hard-delete a meal by id.
  Future<int> deleteMeal(int mealId) {
    return (delete(meals)..where((m) => m.id.equals(mealId))).go();
  }
}
