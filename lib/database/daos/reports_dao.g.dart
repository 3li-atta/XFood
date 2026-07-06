// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports_dao.dart';

// ignore_for_file: type=lint
mixin _$ReportsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $ShiftsTable get shifts => attachedDatabase.shifts;
  $TablesTable get tables => attachedDatabase.tables;
  $TransactionsTable get transactions => attachedDatabase.transactions;
  $MealsTable get meals => attachedDatabase.meals;
  $IngredientsTable get ingredients => attachedDatabase.ingredients;
  $TransactionItemsTable get transactionItems =>
      attachedDatabase.transactionItems;
  $RecipesTable get recipes => attachedDatabase.recipes;
  $ExpensesTable get expenses => attachedDatabase.expenses;
  ReportsDaoManager get managers => ReportsDaoManager(this);
}

class ReportsDaoManager {
  final _$ReportsDaoMixin _db;
  ReportsDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$ShiftsTableTableManager get shifts =>
      $$ShiftsTableTableManager(_db.attachedDatabase, _db.shifts);
  $$TablesTableTableManager get tables =>
      $$TablesTableTableManager(_db.attachedDatabase, _db.tables);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db.attachedDatabase, _db.transactions);
  $$MealsTableTableManager get meals =>
      $$MealsTableTableManager(_db.attachedDatabase, _db.meals);
  $$IngredientsTableTableManager get ingredients =>
      $$IngredientsTableTableManager(_db.attachedDatabase, _db.ingredients);
  $$TransactionItemsTableTableManager get transactionItems =>
      $$TransactionItemsTableTableManager(
          _db.attachedDatabase, _db.transactionItems);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db.attachedDatabase, _db.recipes);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db.attachedDatabase, _db.expenses);
}
