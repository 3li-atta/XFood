import 'package:equatable/equatable.dart';
import '../../../../core/entities/ingredient_entity.dart';

/// Pure domain entity for a Recipe entry (Meal ↔ Ingredient link).
class RecipeEntity extends Equatable {
  final int id;
  final int mealId;
  final int ingredientId;
  final double quantityRequired;

  const RecipeEntity({
    required this.id,
    required this.mealId,
    required this.ingredientId,
    required this.quantityRequired,
  });

  @override
  List<Object?> get props => [id, mealId, ingredientId, quantityRequired];
}

/// A recipe entry enriched with full ingredient details (for display).
class RecipeDetailEntity extends Equatable {
  final RecipeEntity recipe;
  final IngredientEntity ingredient;

  const RecipeDetailEntity({
    required this.recipe,
    required this.ingredient,
  });

  /// Cost contribution of this ingredient to the meal.
  double get ingredientCost =>
      recipe.quantityRequired * ingredient.costPrice;

  @override
  List<Object?> get props => [recipe, ingredient];
}
