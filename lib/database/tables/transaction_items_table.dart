import 'package:drift/drift.dart';
import 'transactions_table.dart';
import 'meals_table.dart';
import 'ingredients_table.dart';

/// TransactionItems table — line items for each transaction.
///
/// Either [mealId] or [ingredientId] is set (not both).
/// - For sales: [mealId] is set, [itemType] = 'meal'
/// - For purchases/waste: [ingredientId] is set, [itemType] = 'ingredient'
/// - [priceAtTime] snapshots the price at transaction time for accurate reports.
class TransactionItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get transactionId => integer().references(Transactions, #id)();
  IntColumn get mealId => integer().nullable().references(Meals, #id)();
  IntColumn get ingredientId =>
      integer().nullable().references(Ingredients, #id)();
  RealColumn get quantity => real()();
  RealColumn get priceAtTime => real()();
  TextColumn get itemType => text().withLength(min: 4, max: 20)();
}
