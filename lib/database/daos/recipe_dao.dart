import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/recipes_table.dart';
import '../tables/ingredients_table.dart';
import '../tables/meals_table.dart';

part 'recipe_dao.g.dart';

/// Data Access Object for recipe operations (Meal ↔ Ingredient bridge).
@DriftAccessor(tables: [Recipes, Ingredients, Meals])
class RecipeDao extends DatabaseAccessor<AppDatabase> with _$RecipeDaoMixin {
  RecipeDao(super.db);

  /// Get all recipe entries for a specific meal (with ingredient details).
  Future<List<RecipeWithIngredient>> getRecipeForMeal(int mealId) async {
    final query = select(recipes).join([
      innerJoin(ingredients, ingredients.id.equalsExp(recipes.ingredientId)),
    ])
      ..where(recipes.mealId.equals(mealId));

    final rows = await query.get();
    return rows.map((row) {
      return RecipeWithIngredient(
        recipe: row.readTable(recipes),
        ingredient: row.readTable(ingredients),
      );
    }).toList();
  }

  /// Get all meals that use a specific ingredient.
  Future<List<RecipeWithMeal>> getMealsUsingIngredient(int ingredientId) async {
    final query = select(recipes).join([
      innerJoin(meals, meals.id.equalsExp(recipes.mealId)),
    ])
      ..where(recipes.ingredientId.equals(ingredientId));

    final rows = await query.get();
    return rows.map((row) {
      return RecipeWithMeal(
        recipe: row.readTable(recipes),
        meal: row.readTable(meals),
      );
    }).toList();
  }

  /// Add an ingredient to a meal's recipe.
  Future<int> addIngredientToRecipe(RecipesCompanion entry) {
    return into(recipes).insert(entry);
  }

  /// Update the quantity required for an existing recipe entry.
  Future<bool> updateQuantity(int recipeId, double newQuantity) {
    return (update(recipes)..where((r) => r.id.equals(recipeId)))
        .write(RecipesCompanion(quantityRequired: Value(newQuantity)))
        .then((rows) => rows > 0);
  }

  /// Remove an ingredient from a meal's recipe.
  Future<int> removeIngredientFromRecipe(int recipeId) {
    return (delete(recipes)..where((r) => r.id.equals(recipeId))).go();
  }

  /// Remove all recipe entries for a meal.
  Future<int> clearRecipeForMeal(int mealId) {
    return (delete(recipes)..where((r) => r.mealId.equals(mealId))).go();
  }

  /// Replace an entire meal's recipe (delete old + insert new, atomically).
  Future<void> replaceRecipe(
      int mealId, List<RecipesCompanion> newEntries) async {
    await transaction(() async {
      await clearRecipeForMeal(mealId);
      for (final entry in newEntries) {
        await into(recipes).insert(entry);
      }
    });
  }
}

/// A recipe entry joined with its ingredient details.
class RecipeWithIngredient {
  final Recipe recipe;
  final Ingredient ingredient;

  RecipeWithIngredient({required this.recipe, required this.ingredient});
}

/// A recipe entry joined with its meal details.
class RecipeWithMeal {
  final Recipe recipe;
  final Meal meal;

  RecipeWithMeal({required this.recipe, required this.meal});
}
