import 'package:drift/drift.dart';
import 'users_table.dart';

/// UserPermissions table — granular permissions assigned to POS users.
@TableIndex(name: 'idx_user_permissions_user_id', columns: {#userId})
class UserPermissions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get permission => text().withLength(min: 1, max: 100)();
}
