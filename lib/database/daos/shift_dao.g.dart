// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_dao.dart';

// ignore_for_file: type=lint
mixin _$ShiftDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $ShiftsTable get shifts => attachedDatabase.shifts;
  $TreasuryTransactionsTable get treasuryTransactions =>
      attachedDatabase.treasuryTransactions;
  ShiftDaoManager get managers => ShiftDaoManager(this);
}

class ShiftDaoManager {
  final _$ShiftDaoMixin _db;
  ShiftDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$ShiftsTableTableManager get shifts =>
      $$ShiftsTableTableManager(_db.attachedDatabase, _db.shifts);
  $$TreasuryTransactionsTableTableManager get treasuryTransactions =>
      $$TreasuryTransactionsTableTableManager(
          _db.attachedDatabase, _db.treasuryTransactions);
}
