import 'package:drift/drift.dart';
import 'users_table.dart';
import 'shifts_table.dart';

/// TreasuryTransactions table — logs cash movements inside the system.
class TreasuryTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get shiftId => integer().nullable().references(Shifts, #id)();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get type => text().withLength(min: 4, max: 30)(); // 'sale_income', 'purchase_expense', 'cash_in', 'cash_out', 'shift_open', 'shift_close'
  RealColumn get amount => real()();
  TextColumn get referenceType => text().nullable()(); // 'transaction', 'purchase_invoice', 'manual'
  IntColumn get referenceId => integer().nullable()();
  TextColumn get description => text().nullable()();
  RealColumn get balanceAfter => real()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
