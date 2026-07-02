import '../entities/transaction_entity.dart';
import '../entities/transaction_item_entity.dart';

/// Abstract repository contract for transaction operations.
abstract class TransactionRepository {
  /// Get all transactions, newest first.
  Future<List<TransactionEntity>> getAllTransactions();

  /// Get transactions filtered by type.
  Future<List<TransactionEntity>> getTransactionsByType(String type);

  /// Get transactions within a date range.
  Future<List<TransactionEntity>> getTransactionsByDateRange(
      DateTime start, DateTime end);

  /// Get line items for a specific transaction.
  Future<List<TransactionItemEntity>> getTransactionItems(int transactionId, {String? type});

  /// Watch all transactions (reactive stream for dashboard).
  Stream<List<TransactionEntity>> watchAllTransactions();

  /// Create a sale with automatic stock deduction.
  /// Returns the new transaction id.
  Future<int> createSale({
    required int userId,
    required int? shiftId,
    required double totalAmount,
    required String? notes,
    required List<SaleInput> items,
  });

  /// Record waste.
  Future<int> recordWaste({
    required int userId,
    required String? notes,
    required List<WasteInput> items,
  });
}

/// Input DTO for sale items.
class SaleInput {
  final int mealId;
  final double quantity;
  final double priceAtTime;

  const SaleInput({
    required this.mealId,
    required this.quantity,
    required this.priceAtTime,
  });
}

/// Input DTO for purchase items.
class PurchaseInput {
  final int ingredientId;
  final double quantity;
  final double costPrice;

  const PurchaseInput({
    required this.ingredientId,
    required this.quantity,
    required this.costPrice,
  });
}

/// Input DTO for waste items.
class WasteInput {
  final int ingredientId;
  final double quantity;

  const WasteInput({
    required this.ingredientId,
    required this.quantity,
  });
}
