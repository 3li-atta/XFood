// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_dao.dart';

// ignore_for_file: type=lint
mixin _$TableDaoMixin on DatabaseAccessor<AppDatabase> {
  $TablesTable get tables => attachedDatabase.tables;
  TableDaoManager get managers => TableDaoManager(this);
}

class TableDaoManager {
  final _$TableDaoMixin _db;
  TableDaoManager(this._db);
  $$TablesTableTableManager get tables =>
      $$TablesTableTableManager(_db.attachedDatabase, _db.tables);
}
