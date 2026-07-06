import 'dart:async';
import 'dart:convert';
import 'package:xfood_pos/core/services/lan_sync/lan_client_service.dart';
import 'package:xfood_pos/core/services/lan_sync/ws_events.dart';
import 'package:xfood_pos/features/transactions/domain/entities/profit_loss_report_entity.dart';
import 'package:xfood_pos/features/transactions/domain/entities/transaction_entity.dart';
import 'package:xfood_pos/features/transactions/domain/entities/transaction_item_entity.dart';
import 'package:xfood_pos/features/transactions/domain/repositories/transaction_repository.dart';

/// Client-side implementation of [TransactionRepository] that delegates core operations
/// (like submitting orders/sales) to the Master server over the LAN network.
class RemoteTransactionRepository implements TransactionRepository {
  final LanClientService _client;

  RemoteTransactionRepository(this._client);

  @override
  Future<int> createSale({
    required int userId,
    required int? shiftId,
    required double totalAmount,
    required double discountPercentage,
    required double taxPercentage,
    required List<SaleInput> items,
    String? notes,
    String orderType = 'takeaway',
    String paymentMethod = 'cash',
    int? tableId,
  }) async {
    final payload = {
      'userId': userId,
      'shiftId': shiftId,
      'totalAmount': totalAmount,
      'discountPercentage': discountPercentage,
      'taxPercentage': taxPercentage,
      'notes': notes,
      'orderType': orderType,
      'paymentMethod': paymentMethod,
      'tableId': tableId,
      'items': items.map((i) => {
        'mealId': i.mealId,
        'quantity': i.quantity,
        'priceAtTime': i.priceAtTime,
      }).toList(),
    };

    final response = await _client.post('/api/orders', payload);
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['id'] as int;
    }
    
    // Parse error if present
    String? errorMessage;
    try {
      final errorData = jsonDecode(response.body);
      errorMessage = errorData['error'] as String?;
    } catch (_) {
      // Body is not JSON
    }

    if (errorMessage != null) {
      throw Exception(errorMessage);
    } else {
      throw Exception('HTTP ${response.statusCode}: Failed to submit order to master server');
    }
  }

  @override
  Future<List<TransactionEntity>> getAllTransactions({int limit = 50, int offset = 0}) async {
    // Waiter tablets do not require historical list views, but return empty list to satisfy contract
    return [];
  }

  @override
  Future<List<TransactionEntity>> getTransactionsByType(String type, {int limit = 50, int offset = 0}) async {
    return [];
  }

  @override
  Future<List<TransactionEntity>> getTransactionsByDateRange(DateTime start, DateTime end) async {
    return [];
  }

  @override
  Future<List<TransactionItemEntity>> getTransactionItems(int transactionId, {String? type}) async {
    return [];
  }

  @override
  Stream<List<TransactionEntity>> watchAllTransactions() {
    // Returns empty stream for clients
    return const Stream.empty();
  }

  @override
  Future<int> recordWaste({
    required int userId,
    required String? notes,
    required List<WasteInput> items,
  }) {
    throw UnsupportedError('Waste recording is only supported on the Master cashier device.');
  }

  @override
  Future<ProfitLossReportEntity> getProfitLossReport(DateTime start, DateTime end) {
    throw UnsupportedError('P&L reports are only supported on the Master cashier device.');
  }

  @override
  Future<bool> refundSaleTransaction(int transactionId, int userId, String reason) {
    throw UnsupportedError('Order refunding is only supported on the Master cashier device.');
  }

  @override
  Future<bool> isTransactionRefunded(int transactionId) async {
    return false;
  }
}
