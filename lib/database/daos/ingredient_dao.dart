import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/ingredients_table.dart';

part 'ingredient_dao.g.dart';

/// Data Access Object for ingredient / raw material operations.
@DriftAccessor(tables: [Ingredients])
class IngredientDao extends DatabaseAccessor<AppDatabase>
    with _$IngredientDaoMixin {
  IngredientDao(super.db);

  /// Get all ingredients, ordered by name.
  Future<List<Ingredient>> getAllIngredients() {
    return (select(ingredients)
          ..orderBy([(i) => OrderingTerm.asc(i.name)]))
        .get();
  }

  /// Get a single ingredient by id.
  Future<Ingredient> getById(int id) {
    return (select(ingredients)..where((i) => i.id.equals(id))).getSingle();
  }

  /// Watch all ingredients (reactive stream for UI).
  Stream<List<Ingredient>> watchAllIngredients() {
    return (select(ingredients)
          ..orderBy([(i) => OrderingTerm.asc(i.name)]))
        .watch();
  }

  /// Get ingredients with low stock (below a threshold).
  Future<List<Ingredient>> getLowStockIngredients(double threshold) {
    return (select(ingredients)
          ..where((i) => i.currentStock.isSmallerOrEqualValue(threshold)))
        .get();
  }

  /// Insert a new ingredient. Returns the auto-generated id.
  Future<int> insertIngredient(IngredientsCompanion ingredient) {
    return into(ingredients).insert(ingredient);
  }

  /// Update an ingredient's stock level.
  Future<bool> updateStock(int ingredientId, double newStock) {
    return (update(ingredients)..where((i) => i.id.equals(ingredientId)))
        .write(IngredientsCompanion(
          currentStock: Value(newStock),
          updatedAt: Value(DateTime.now()),
        ))
        .then((rows) => rows > 0);
  }

  /// Update ingredient details.
  Future<bool> updateIngredient(
      int ingredientId, IngredientsCompanion companion) {
    return (update(ingredients)..where((i) => i.id.equals(ingredientId)))
        .write(companion)
        .then((rows) => rows > 0);
  }

  /// Delete an ingredient by id.
  Future<int> deleteIngredient(int ingredientId) {
    return (delete(ingredients)..where((i) => i.id.equals(ingredientId))).go();
  }
}
