import 'package:drift/drift.dart';
import 'users_table.dart';

/// AuditLogs table — logs all security and critical financial events for accountability.
class AuditLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get action => text().withLength(min: 2, max: 50)(); // 'refund_sale', 'void_purchase', 'manual_adjustment', etc.
  TextColumn get details => text().nullable()(); // JSON string or descriptive notes
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
