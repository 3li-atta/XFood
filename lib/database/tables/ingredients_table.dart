import 'package:drift/drift.dart';

/// Ingredients table — raw materials / stock items.
///
/// - [currentStock] is a real to support fractional units (e.g., 2.5 kg).
/// - [costPrice] is the cost per single unit of measurement.
class Ingredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique().withLength(min: 1, max: 100)();
  TextColumn get unitOfMeasurement => text().withLength(min: 1, max: 20)();
  RealColumn get currentStock => real().withDefault(const Constant(0.0))();
  RealColumn get costPrice => real()();
  RealColumn get minStockAlert => real().withDefault(const Constant(10.0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
