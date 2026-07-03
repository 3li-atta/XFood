import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/users_table.dart';
import 'tables/ingredients_table.dart';
import 'tables/meals_table.dart';
import 'tables/recipes_table.dart';
import 'tables/transactions_table.dart';
import 'tables/transaction_items_table.dart';
import 'tables/shifts_table.dart';
import 'tables/purchase_invoices_table.dart';
import 'tables/purchase_items_table.dart';
import 'tables/treasury_transactions_table.dart';
import 'tables/expenses_table.dart';

import 'daos/user_dao.dart';
import 'daos/ingredient_dao.dart';
import 'daos/meal_dao.dart';
import 'daos/recipe_dao.dart';
import 'daos/transaction_dao.dart';
import 'daos/shift_dao.dart';
import 'daos/purchase_dao.dart';
import 'daos/treasury_dao.dart';
import 'daos/expense_dao.dart';

part 'app_database.g.dart';

/// Central Drift database for the XFood POS application.
///
/// Registers all tables and DAOs. Uses a single SQLite file
/// stored in the app's documents directory.
@DriftDatabase(
  tables: [
    Users,
    Ingredients,
    Meals,
    Recipes,
    Transactions,
    TransactionItems,
    Shifts,
    PurchaseInvoices,
    PurchaseItems,
    TreasuryTransactions,
    Expenses,
  ],
  daos: [
    UserDao,
    IngredientDao,
    MealDao,
    RecipeDao,
    TransactionDao,
    ShiftDao,
    PurchaseDao,
    TreasuryDao,
    ExpenseDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Production constructor — uses file-based SQLite.
  AppDatabase() : super(_openConnection());

  /// Test constructor — accepts an in-memory executor.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            // Create new tables
            await m.create(shifts);
            await m.create(purchaseInvoices);
            await m.create(purchaseItems);
            await m.create(treasuryTransactions);
            
            // Add new columns to existing tables
            await m.addColumn(users, users.mustChangePassword);
            await m.addColumn(transactions, transactions.shiftId);

            // Run migration script to move purchase transactions (Phase 2)
            await customStatement('PRAGMA foreign_keys = OFF');
            
            // 1. Fetch old purchases
            final oldPurchases = await customSelect(
              "SELECT * FROM transactions WHERE type = 'purchase'",
            ).get();

            double runningBalance = 0.0;

            for (final pRow in oldPurchases) {
              final id = pRow.read<int>('id');
              final userId = pRow.read<int>('user_id');
              final totalAmount = pRow.read<double>('total_amount');
              final notes = pRow.read<String?>('notes');
              final createdAt = pRow.read<DateTime>('created_at');

              // Create invoice number
              final invoiceNumber = 'PUR-HIST-${id.toString().padLeft(4, '0')}';

              // Insert purchase invoice
              final invoiceId = await customInsert(
                'INSERT INTO purchase_invoices (invoice_number, supplier_name, user_id, total_amount, notes, status, created_at, updated_at) '
                'VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
                variables: [
                  Variable<String>(invoiceNumber),
                  const Variable<String>('Historical Supplier'),
                  Variable<int>(userId),
                  Variable<double>(totalAmount),
                  Variable<String>(notes),
                  const Variable<String>('completed'),
                  Variable<DateTime>(createdAt),
                  Variable<DateTime>(createdAt),
                ],
              );

              // Fetch old purchase items
              final oldItems = await customSelect(
                'SELECT * FROM transaction_items WHERE transaction_id = ?',
                variables: [Variable<int>(id)],
              ).get();

              for (final iRow in oldItems) {
                final ingredientId = iRow.read<int?>('ingredient_id');
                final quantity = iRow.read<double>('quantity');
                final priceAtTime = iRow.read<double>('price_at_time');

                if (ingredientId != null) {
                  await customInsert(
                    'INSERT INTO purchase_items (purchase_invoice_id, ingredient_id, quantity, unit_cost, line_total, created_at) '
                    'VALUES (?, ?, ?, ?, ?, ?)',
                    variables: [
                      Variable<int>(invoiceId),
                      Variable<int>(ingredientId),
                      Variable<double>(quantity),
                      Variable<double>(priceAtTime),
                      Variable<double>(quantity * priceAtTime),
                      Variable<DateTime>(createdAt),
                    ],
                  );
                }
              }

              // Delete old purchase transaction and items
              await customStatement('DELETE FROM transaction_items WHERE transaction_id = ?', [id]);
              await customStatement('DELETE FROM transactions WHERE id = ?', [id]);

              // Add to treasury running balance
              runningBalance -= totalAmount;
              await customInsert(
                'INSERT INTO treasury_transactions (user_id, type, amount, reference_type, reference_id, description, balance_after, created_at) '
                'VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
                variables: [
                  Variable<int>(userId),
                  const Variable<String>('purchase_expense'),
                  Variable<double>(totalAmount),
                  const Variable<String>('purchase_invoice'),
                  Variable<int>(invoiceId),
                  Variable<String>('Historical Purchase Invoice #$invoiceNumber'),
                  Variable<double>(runningBalance),
                  Variable<DateTime>(createdAt),
                ],
              );
            }

            // 2. Backfill Treasury logs for existing Sales
            final oldSales = await customSelect(
              "SELECT * FROM transactions WHERE type = 'sale' ORDER BY created_at ASC",
            ).get();

            for (final sRow in oldSales) {
              final id = sRow.read<int>('id');
              final userId = sRow.read<int>('user_id');
              final totalAmount = sRow.read<double>('total_amount');
              final createdAt = sRow.read<DateTime>('created_at');

              runningBalance += totalAmount;
              await customInsert(
                'INSERT INTO treasury_transactions (user_id, type, amount, reference_type, reference_id, description, balance_after, created_at) '
                'VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
                variables: [
                  Variable<int>(userId),
                  const Variable<String>('sale_income'),
                  Variable<double>(totalAmount),
                  const Variable<String>('transaction'),
                  Variable<int>(id),
                  Variable<String>('Historical Sale Transaction #$id'),
                  Variable<double>(runningBalance),
                  Variable<DateTime>(createdAt),
                ],
              );
            }

            await customStatement('PRAGMA foreign_keys = ON');
          }
          if (from < 3) {
            await m.create(expenses);
          }
        },
        beforeOpen: (details) async {
          // Enable foreign key enforcement in SQLite.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

/// Opens a persistent SQLite database connection.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'xfood_pos.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
