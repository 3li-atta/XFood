import 'package:drift/drift.dart';
import 'users_table.dart';
import 'shifts_table.dart';

/// Transactions table — records all financial events.
///
/// Types: sale, purchase, waste, inventoryCheck.
/// Each transaction is linked to the [userId] who created it.
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  IntColumn get shiftId => integer().nullable().references(Shifts, #id)();
  TextColumn get type => text().withLength(min: 4, max: 20)();
  RealColumn get totalAmount => real()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
