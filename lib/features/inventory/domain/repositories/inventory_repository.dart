import '../../../../core/entities/ingredient_entity.dart';

/// Abstract repository contract for inventory / ingredient operations.
abstract class InventoryRepository {
  /// Get all ingredients.
  Future<List<IngredientEntity>> getAllIngredients();

  /// Get a single ingredient by id.
  Future<IngredientEntity> getIngredientById(int id);

  /// Watch all ingredients (reactive stream).
  Stream<List<IngredientEntity>> watchAllIngredients();

  /// Get ingredients with low stock.
  Future<List<IngredientEntity>> getLowStockIngredients(double threshold);

  /// Add a new ingredient.
  Future<IngredientEntity> addIngredient({
    required String name,
    required String unitOfMeasurement,
    required double currentStock,
    required double costPrice,
  });

  /// Update stock level for an ingredient.
  Future<bool> updateStock(int ingredientId, double newStock);

  /// Update ingredient details.
  Future<bool> updateIngredient(int ingredientId, {
    String? name,
    String? unitOfMeasurement,
    double? costPrice,
  });

  /// Delete an ingredient.
  Future<bool> deleteIngredient(int ingredientId);
}
