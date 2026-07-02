import 'package:drift/drift.dart';
import 'purchase_invoices_table.dart';
import 'ingredients_table.dart';

/// PurchaseItems table — records item lines for each purchase invoice.
class PurchaseItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get purchaseInvoiceId => integer().references(PurchaseInvoices, #id, onDelete: KeyAction.cascade)();
  IntColumn get ingredientId => integer().references(Ingredients, #id)();
  RealColumn get quantity => real()();
  RealColumn get unitCost => real()();
  RealColumn get lineTotal => real()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
