import 'package:drift/drift.dart';
import 'users_table.dart';
import 'shifts_table.dart';

/// PurchaseInvoices table — records procurement actions.
class PurchaseInvoices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get invoiceNumber => text().unique()();
  TextColumn get supplierName => text().nullable()();
  IntColumn get userId => integer().references(Users, #id)();
  IntColumn get shiftId => integer().nullable().references(Shifts, #id)();
  RealColumn get totalAmount => real()();
  TextColumn get notes => text().nullable()();
  TextColumn get status => text().withLength(min: 4, max: 20).withDefault(const Constant('completed'))(); // 'completed', 'voided'
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
