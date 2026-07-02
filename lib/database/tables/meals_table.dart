import 'package:drift/drift.dart';

/// Meals table — final products / menu items.
///
/// - [isActive] enables soft-delete (hide from POS without losing history).
/// - [category] groups meals for display (Appetizer, Main Course, etc.).
class Meals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  RealColumn get sellingPrice => real()();
  TextColumn get category => text().withLength(min: 1, max: 50)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
