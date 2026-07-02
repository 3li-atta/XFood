import 'package:drift/drift.dart';
import 'users_table.dart';

/// Shifts table — manages cashier shifts and cash drawer reconciliation.
class Shifts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cashierId => integer().references(Users, #id)();
  TextColumn get status => text().withLength(min: 4, max: 10).withDefault(const Constant('open'))(); // 'open', 'closed'
  RealColumn get startingCash => real()();
  RealColumn get expectedClosingCash => real().nullable()();
  RealColumn get actualClosingCash => real().nullable()();
  RealColumn get variance => real().nullable()();
  RealColumn get totalSales => real().withDefault(const Constant(0.0))();
  RealColumn get totalPurchases => real().withDefault(const Constant(0.0))();
  RealColumn get totalCashIn => real().withDefault(const Constant(0.0))();
  RealColumn get totalCashOut => real().withDefault(const Constant(0.0))();
  DateTimeColumn get openedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get closedAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
}
