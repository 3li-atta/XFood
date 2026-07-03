import 'package:drift/drift.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../domain/repositories/meal_repository.dart';
import '../../../../core/entities/ingredient_entity.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../database/app_database.dart';
import '../../../../database/daos/meal_dao.dart';
import '../../../../database/daos/recipe_dao.dart';

/// Concrete implementation of [MealRepository] using Drift DAOs.
class MealRepositoryImpl implements MealRepository {
  final MealDao _mealDao;
  final RecipeDao _recipeDao;

  MealRepositoryImpl(this._mealDao, this._recipeDao);

  @override
  Future<List<MealEntity>> getActiveMeals() async {
    final rows = await _mealDao.getActiveMeals();
    return rows.map(_mapMealToEntity).toList();
  }

  @override
  Future<List<MealEntity>> getAllMeals() async {
    final rows = await _mealDao.getAllMeals();
    return rows.map(_mapMealToEntity).toList();
  }

  @override
  Future<List<MealEntity>> getMealsByCategory(String category) async {
    final rows = await _mealDao.getMealsByCategory(category);
    return rows.map(_mapMealToEntity).toList();
  }

  @override
  Stream<List<MealEntity>> watchActiveMeals() {
    return _mealDao.watchActiveMeals().map(
          (rows) => rows.map(_mapMealToEntity).toList(),
        );
  }

  @override
  Stream<List<MealEntity>> watchAllMeals() {
    return _mealDao.watchAllMeals().map(
          (rows) => rows.map(_mapMealToEntity).toList(),
        );
  }

  @override
  Future<MealEntity> getMealById(int id) async {
    try {
      final row = await _mealDao.getById(id);
      return _mapMealToEntity(row);
    } catch (_) {
      throw NotFoundException('Meal', id);
    }
  }

  @override
  Future<MealEntity> createMeal({
    required String name,
    required double sellingPrice,
    required String category,
  }) async {
    final id = await _mealDao.insertMeal(MealsCompanion.insert(
      name: name,
      sellingPrice: sellingPrice,
      category: category,
    ));
    return getMealById(id);
  }

  @override
  Future<bool> updateMeal(
    int mealId, {
    String? name,
    double? sellingPrice,
    String? category,
    bool? isActive,
  }) {
    final companion = MealsCompanion(
      name: name != null ? Value(name) : const Value.absent(),
      sellingPrice:
          sellingPrice != null ? Value(sellingPrice) : const Value.absent(),
      category: category != null ? Value(category) : const Value.absent(),
      isActive: isActive != null ? Value(isActive) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    );
    return _mealDao.updateMeal(mealId, companion);
  }

  @override
  Future<bool> deactivateMeal(int mealId) {
    return _mealDao.deactivateMeal(mealId);
  }

  @override
  Future<bool> toggleMealActive(int mealId, bool isActive) {
    return _mealDao.toggleMealActive(mealId, isActive);
  }

  @override
  Future<List<RecipeDetailEntity>> getRecipeForMeal(int mealId) async {
    final rows = await _recipeDao.getRecipeForMeal(mealId);
    return rows.map((r) {
      return RecipeDetailEntity(
        recipe: RecipeEntity(
          id: r.recipe.id,
          mealId: r.recipe.mealId,
          ingredientId: r.recipe.ingredientId,
          quantityRequired: r.recipe.quantityRequired,
        ),
        ingredient: IngredientEntity(
          id: r.ingredient.id,
          name: r.ingredient.name,
          unitOfMeasurement: r.ingredient.unitOfMeasurement,
          currentStock: r.ingredient.currentStock,
          costPrice: r.ingredient.costPrice,
          createdAt: r.ingredient.createdAt,
          updatedAt: r.ingredient.updatedAt,
        ),
      );
    }).toList();
  }

  @override
  Future<void> setRecipe(
      int mealId, List<RecipeIngredientInput> ingredients) async {
    final entries = ingredients
        .map((i) => RecipesCompanion.insert(
              mealId: mealId,
              ingredientId: i.ingredientId,
              quantityRequired: i.quantityRequired,
            ))
        .toList();
    await _recipeDao.replaceRecipe(mealId, entries);
  }

  @override
  Future<double> calculateMealCost(int mealId) async {
    final recipe = await getRecipeForMeal(mealId);
    return recipe.fold<double>(0, (sum, r) => sum + r.ingredientCost);
  }

  MealEntity _mapMealToEntity(Meal row) {
    return MealEntity(
      id: row.id,
      name: row.name,
      sellingPrice: row.sellingPrice,
      category: row.category,
      isActive: row.isActive,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
