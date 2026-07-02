// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_dao.dart';

// ignore_for_file: type=lint
mixin _$PurchaseDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $ShiftsTable get shifts => attachedDatabase.shifts;
  $PurchaseInvoicesTable get purchaseInvoices =>
      attachedDatabase.purchaseInvoices;
  $IngredientsTable get ingredients => attachedDatabase.ingredients;
  $PurchaseItemsTable get purchaseItems => attachedDatabase.purchaseItems;
  $TreasuryTransactionsTable get treasuryTransactions =>
      attachedDatabase.treasuryTransactions;
  PurchaseDaoManager get managers => PurchaseDaoManager(this);
}

class PurchaseDaoManager {
  final _$PurchaseDaoMixin _db;
  PurchaseDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$ShiftsTableTableManager get shifts =>
      $$ShiftsTableTableManager(_db.attachedDatabase, _db.shifts);
  $$PurchaseInvoicesTableTableManager get purchaseInvoices =>
      $$PurchaseInvoicesTableTableManager(
          _db.attachedDatabase, _db.purchaseInvoices);
  $$IngredientsTableTableManager get ingredients =>
      $$IngredientsTableTableManager(_db.attachedDatabase, _db.ingredients);
  $$PurchaseItemsTableTableManager get purchaseItems =>
      $$PurchaseItemsTableTableManager(_db.attachedDatabase, _db.purchaseItems);
  $$TreasuryTransactionsTableTableManager get treasuryTransactions =>
      $$TreasuryTransactionsTableTableManager(
          _db.attachedDatabase, _db.treasuryTransactions);
}
