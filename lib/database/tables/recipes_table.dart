import 'package:drift/drift.dart';
import 'meals_table.dart';
import 'ingredients_table.dart';

/// Recipes table — bridge/junction connecting Meals to Ingredients.
///
/// Each row says: "To make 1 unit of [mealId], you need [quantityRequired]
/// of [ingredientId]."
///
/// The unique key on (mealId, ingredientId) prevents duplicate entries.
class Recipes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get mealId => integer().references(Meals, #id)();
  IntColumn get ingredientId => integer().references(Ingredients, #id)();
  RealColumn get quantityRequired => real()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {mealId, ingredientId},
      ];
}
