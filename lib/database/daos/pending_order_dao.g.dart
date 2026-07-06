// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_order_dao.dart';

// ignore_for_file: type=lint
mixin _$PendingOrderDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $TablesTable get tables => attachedDatabase.tables;
  $PendingOrdersTable get pendingOrders => attachedDatabase.pendingOrders;
  PendingOrderDaoManager get managers => PendingOrderDaoManager(this);
}

class PendingOrderDaoManager {
  final _$PendingOrderDaoMixin _db;
  PendingOrderDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$TablesTableTableManager get tables =>
      $$TablesTableTableManager(_db.attachedDatabase, _db.tables);
  $$PendingOrdersTableTableManager get pendingOrders =>
      $$PendingOrdersTableTableManager(_db.attachedDatabase, _db.pendingOrders);
}
