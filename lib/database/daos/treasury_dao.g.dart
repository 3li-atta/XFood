// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treasury_dao.dart';

// ignore_for_file: type=lint
mixin _$TreasuryDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $ShiftsTable get shifts => attachedDatabase.shifts;
  $TreasuryTransactionsTable get treasuryTransactions =>
      attachedDatabase.treasuryTransactions;
  TreasuryDaoManager get managers => TreasuryDaoManager(this);
}

class TreasuryDaoManager {
  final _$TreasuryDaoMixin _db;
  TreasuryDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$ShiftsTableTableManager get shifts =>
      $$ShiftsTableTableManager(_db.attachedDatabase, _db.shifts);
  $$TreasuryTransactionsTableTableManager get treasuryTransactions =>
      $$TreasuryTransactionsTableTableManager(
          _db.attachedDatabase, _db.treasuryTransactions);
}
