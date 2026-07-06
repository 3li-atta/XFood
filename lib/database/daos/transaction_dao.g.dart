// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_dao.dart';

// ignore_for_file: type=lint
mixin _$TransactionDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $ShiftsTable get shifts => attachedDatabase.shifts;
  $TablesTable get tables => attachedDatabase.tables;
  $TransactionsTable get transactions => attachedDatabase.transactions;
  $MealsTable get meals => attachedDatabase.meals;
  $IngredientsTable get ingredients => attachedDatabase.ingredients;
  $TransactionItemsTable get transactionItems =>
      attachedDatabase.transactionItems;
  $RecipesTable get recipes => attachedDatabase.recipes;
  $TreasuryTransactionsTable get treasuryTransactions =>
      attachedDatabase.treasuryTransactions;
  TransactionDaoManager get managers => TransactionDaoManager(this);
}

class TransactionDaoManager {
  final _$TransactionDaoMixin _db;
  TransactionDaoManager(this._db);
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
  $$TreasuryTransactionsTableTableManager get treasuryTransactions =>
      $$TreasuryTransactionsTableTableManager(
          _db.attachedDatabase, _db.treasuryTransactions);
}
