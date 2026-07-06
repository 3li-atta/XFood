import 'package:drift/drift.dart';
import 'users_table.dart';
import 'tables_table.dart';

/// PendingOrders table — stores parked/held orders temporarily before finalization.
class PendingOrders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  IntColumn get tableId => integer().nullable().references(Tables, #id)();
  TextColumn get orderType => text().withLength(min: 4, max: 20)(); // 'dine_in', 'takeaway', 'delivery'
  TextColumn get notes => text().nullable()();
  RealColumn get discountPercentage => real().withDefault(const Constant(0.0))();
  RealColumn get taxPercentage => real().withDefault(const Constant(0.0))();
  TextColumn get cartItemsJson => text()(); // Serialized list of items in the cart
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
