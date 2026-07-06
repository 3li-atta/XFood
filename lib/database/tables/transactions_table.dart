import 'package:drift/drift.dart';
import 'users_table.dart';
import 'shifts_table.dart';
import 'tables_table.dart';

/// Transactions table — records all financial events.
///
/// Types: sale, purchase, waste, inventoryCheck.
/// Each transaction is linked to the [userId] who created it.
@TableIndex(name: 'idx_transactions_created_at', columns: {#createdAt})
@TableIndex(name: 'idx_transactions_type', columns: {#type})
@TableIndex(name: 'idx_transactions_shift_id', columns: {#shiftId})
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  IntColumn get shiftId => integer().nullable().references(Shifts, #id)();
  TextColumn get type => text().withLength(min: 4, max: 20)();
  RealColumn get totalAmount => real()();
  RealColumn get subtotalAmount => real().withDefault(const Constant(0.0))();
  RealColumn get discountAmount => real().withDefault(const Constant(0.0))();
  RealColumn get taxAmount => real().withDefault(const Constant(0.0))();
  TextColumn get orderType => text().withLength(min: 4, max: 20).withDefault(const Constant('takeaway'))(); // 'dine_in', 'takeaway', 'delivery'
  TextColumn get paymentMethod => text().withLength(min: 4, max: 20).withDefault(const Constant('cash'))(); // 'cash', 'card', 'online', 'mixed'
  IntColumn get tableId => integer().nullable().references(Tables, #id)();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
