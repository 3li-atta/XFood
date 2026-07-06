import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:xfood_pos/core/di/injection.dart';
import 'package:xfood_pos/core/services/device_config_service.dart';
import 'package:xfood_pos/core/services/lan_sync/lan_client_service.dart';
import '../app_database.dart';
import '../tables/pending_orders_table.dart';

part 'pending_order_dao.g.dart';

@DriftAccessor(tables: [PendingOrders])
class PendingOrderDao extends DatabaseAccessor<AppDatabase> with _$PendingOrderDaoMixin {
  PendingOrderDao(super.db);

  bool get _isClientMode =>
      getIt.isRegistered<DeviceConfigService>() &&
      !getIt<DeviceConfigService>().isMaster &&
      getIt.isRegistered<LanClientService>();

  /// Insert a new pending/parked order.
  Future<int> insertPendingOrder(PendingOrdersCompanion order) async {
    if (_isClientMode) {
      try {
        final client = getIt<LanClientService>();
        final payload = {
          'userId': order.userId.value,
          'tableId': order.tableId.value,
          'orderType': order.orderType.value,
          'notes': order.notes.value,
          'discountPercentage': order.discountPercentage.value,
          'taxPercentage': order.taxPercentage.value,
          'cartItemsJson': order.cartItemsJson.value,
        };
        final response = await client.post('/api/orders/pending', payload);
        if (response.statusCode == 201) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          return data['id'] as int;
        }
      } catch (_) {}
      return 0;
    }
    return into(pendingOrders).insert(order);
  }

  /// Delete a pending order by id (once loaded/resumed).
  Future<int> deletePendingOrder(int orderId) async {
    if (_isClientMode) {
      try {
        final client = getIt<LanClientService>();
        final response = await client.delete('/api/orders/pending/$orderId');
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          return (data['success'] as bool? ?? false) ? 1 : 0;
        }
      } catch (_) {}
      return 0;
    }
    return (delete(pendingOrders)..where((po) => po.id.equals(orderId))).go();
  }

  /// Get all pending orders.
  Future<List<PendingOrder>> getAllPendingOrders() async {
    if (_isClientMode) {
      try {
        final client = getIt<LanClientService>();
        final response = await client.get('/api/orders/pending');
        if (response.statusCode == 200) {
          final List<dynamic> list = jsonDecode(response.body);
          return list.map((item) => PendingOrder.fromJson(item as Map<String, dynamic>)).toList();
        }
      } catch (_) {}
      return [];
    }
    return (select(pendingOrders)
          ..orderBy([(po) => OrderingTerm.desc(po.createdAt)]))
        .get();
  }

  /// Get pending order by ID.
  Future<PendingOrder?> getPendingOrderById(int id) async {
    if (_isClientMode) {
      try {
        final list = await getAllPendingOrders();
        return list.firstWhere((o) => o.id == id);
      } catch (_) {}
      return null;
    }
    return (select(pendingOrders)..where((po) => po.id.equals(id))).getSingleOrNull();
  }
}
