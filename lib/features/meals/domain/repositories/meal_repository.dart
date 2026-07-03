import '../entities/meal_entity.dart';
import '../entities/recipe_entity.dart';

/// Abstract repository contract for meal and recipe operations.
abstract class MealRepository {
  /// Get all active meals.
  Future<List<MealEntity>> getActiveMeals();

  /// Get all meals (including inactive).
  Future<List<MealEntity>> getAllMeals();

  /// Get meals by category.
  Future<List<MealEntity>> getMealsByCategory(String category);

  /// Watch active meals (reactive stream for POS screen).
  Stream<List<MealEntity>> watchActiveMeals();

  /// Watch all meals (including inactive).
  Stream<List<MealEntity>> watchAllMeals();

  /// Get a single meal by id.
  Future<MealEntity> getMealById(int id);

  /// Create a new meal.
  Future<MealEntity> createMeal({
    required String name,
    required double sellingPrice,
    required String category,
  });

  /// Update meal details.
  Future<bool> updateMeal(int mealId, {
    String? name,
    double? sellingPrice,
    String? category,
    bool? isActive,
  });

  /// Soft-delete (deactivate) a meal.
  Future<bool> deactivateMeal(int mealId);

  /// Toggle active state of a meal.
  Future<bool> toggleMealActive(int mealId, bool isActive);

  /// Get the full recipe for a meal (with ingredient details).
  Future<List<RecipeDetailEntity>> getRecipeForMeal(int mealId);

  /// Set the recipe for a meal (replace all ingredients).
  Future<void> setRecipe(int mealId, List<RecipeIngredientInput> ingredients);

  /// Calculate the total cost to produce one unit of a meal.
  Future<double> calculateMealCost(int mealId);
}

/// Input DTO for setting recipe ingredients.
class RecipeIngredientInput {
  final int ingredientId;
  final double quantityRequired;

  const RecipeIngredientInput({
    required this.ingredientId,
    required this.quantityRequired,
  });
}
