import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:xfood_pos/core/di/injection.dart';
import 'package:xfood_pos/core/services/device_config_service.dart';
import 'package:xfood_pos/core/services/lan_sync/websocket_hub.dart';
import 'package:xfood_pos/core/services/lan_sync/ws_events.dart';
import 'package:xfood_pos/database/app_database.dart';
import 'package:xfood_pos/database/daos/meal_dao.dart';
import 'package:xfood_pos/database/daos/table_dao.dart';
import 'package:xfood_pos/database/daos/pending_order_dao.dart';
import 'package:xfood_pos/database/daos/transaction_dao.dart';
import 'package:xfood_pos/database/daos/shift_dao.dart';
import 'package:drift/drift.dart';

/// Request handlers for the REST API endpoints of the embedded Master server.
class ApiHandlers {
  final MealDao _mealDao;
  final TableDao _tableDao;
  final PendingOrderDao _pendingOrderDao;
  final TransactionDao _transactionDao;
  final ShiftDao _shiftDao;
  final DeviceConfigService _deviceConfig;
  final WebSocketHub _webSocketHub;

  ApiHandlers({
    required MealDao mealDao,
    required TableDao tableDao,
    required PendingOrderDao pendingOrderDao,
    required TransactionDao transactionDao,
    required ShiftDao shiftDao,
    required DeviceConfigService deviceConfig,
    required WebSocketHub webSocketHub,
  })  : _mealDao = mealDao,
        _tableDao = tableDao,
        _pendingOrderDao = pendingOrderDao,
        _transactionDao = transactionDao,
        _shiftDao = shiftDao,
        _deviceConfig = deviceConfig,
        _webSocketHub = webSocketHub;

  /// Helper to generate JSON responses.
  Response _jsonResponse(Map<String, dynamic> body, {int status = 200}) {
    return Response(
      status,
      body: jsonEncode(body),
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }

  /// Helper to generate JSON list responses.
  Response _jsonListResponse(List<dynamic> list, {int status = 200}) {
    return Response(
      status,
      body: jsonEncode(list),
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }

  /// GET /api/health
  Response handleHealth(Request request) {
    return _jsonResponse({
      'status': 'ok',
      'appName': 'XFood POS',
      'deviceName': _deviceConfig.deviceName,
      'role': _deviceConfig.role.name,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    });
  }

  /// GET /api/meals
  Future<Response> handleGetMeals(Request request) async {
    try {
      final meals = await _mealDao.getActiveMeals();
      final list = meals.map((m) => m.toJson()).toList();
      return _jsonListResponse(list);
    } catch (e) {
      return _jsonResponse({'error': 'Failed to fetch meals: $e'}, status: 500);
    }
  }

  /// GET /api/tables
  Future<Response> handleGetTables(Request request) async {
    try {
      final tables = await _tableDao.getAllTables();
      final list = tables.map((t) => t.toJson()).toList();
      return _jsonListResponse(list);
    } catch (e) {
      return _jsonResponse({'error': 'Failed to fetch tables: $e'}, status: 500);
    }
  }

  /// PUT /api/tables/<id>/status
  Future<Response> handleUpdateTableStatus(Request request) async {
    try {
      final idStr = request.params['id'];
      final id = int.tryParse(idStr ?? '');
      if (id == null) {
        return _jsonResponse({'error': 'Invalid table ID'}, status: 400);
      }

      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final status = data['status'] as String?;
      if (status == null) {
        return _jsonResponse({'error': 'Missing status in body'}, status: 400);
      }

      final success = await _tableDao.updateTableStatus(id, status);
      if (success) {
        _webSocketHub.broadcast(
          WsEvents.tableStatusChanged,
          {'tableId': id, 'status': status},
          senderId: 'master',
        );
      }

      return _jsonResponse({'success': success});
    } catch (e) {
      return _jsonResponse({'error': 'Failed to update table status: $e'}, status: 500);
    }
  }

  /// GET /api/orders/pending
  Future<Response> handleGetPendingOrders(Request request) async {
    try {
      final orders = await _pendingOrderDao.getAllPendingOrders();
      final list = orders.map((o) => o.toJson()).toList();
      return _jsonListResponse(list);
    } catch (e) {
      return _jsonResponse({'error': 'Failed to fetch pending orders: $e'}, status: 500);
    }
  }

  /// POST /api/orders/pending
  Future<Response> handleCreatePendingOrder(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final companion = PendingOrdersCompanion(
        userId: Value(data['userId'] as int),
        tableId: Value(data['tableId'] as int?),
        orderType: Value(data['orderType'] as String),
        notes: Value(data['notes'] as String?),
        discountPercentage: Value((data['discountPercentage'] as num?)?.toDouble() ?? 0.0),
        taxPercentage: Value((data['taxPercentage'] as num?)?.toDouble() ?? 0.0),
        cartItemsJson: Value(data['cartItemsJson'] as String),
      );

      final id = await _pendingOrderDao.insertPendingOrder(companion);

      _webSocketHub.broadcast(
        WsEvents.pendingOrderCreated,
        {'orderId': id},
        senderId: 'master',
      );

      return _jsonResponse({'id': id}, status: 201);
    } catch (e) {
      return _jsonResponse({'error': 'Failed to create pending order: $e'}, status: 500);
    }
  }

  /// DELETE /api/orders/pending/<id>
  Future<Response> handleDeletePendingOrder(Request request) async {
    try {
      final idStr = request.params['id'];
      final id = int.tryParse(idStr ?? '');
      if (id == null) {
        return _jsonResponse({'error': 'Invalid pending order ID'}, status: 400);
      }

      final count = await _pendingOrderDao.deletePendingOrder(id);
      final success = count > 0;

      if (success) {
        _webSocketHub.broadcast(
          WsEvents.pendingOrderDeleted,
          {'orderId': id},
          senderId: 'master',
        );
      }

      return _jsonResponse({'success': success});
    } catch (e) {
      return _jsonResponse({'error': 'Failed to delete pending order: $e'}, status: 500);
    }
  }

  /// POST /api/orders
  Future<Response> handleCreateOrder(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final rawItems = data['items'] as List<dynamic>;
      final lineItems = rawItems.map((item) {
        final map = item as Map<String, dynamic>;
        return SaleLineItem(
          mealId: map['mealId'] as int,
          quantity: (map['quantity'] as num).toDouble(),
          priceAtTime: (map['priceAtTime'] as num).toDouble(),
        );
      }).toList();

      final txnId = await _transactionDao.createSaleWithStockDeduction(
        userId: data['userId'] as int,
        shiftId: data['shiftId'] as int?,
        notes: data['notes'] as String?,
        lineItems: lineItems,
        discountPercentage: (data['discountPercentage'] as num?)?.toDouble() ?? 0.0,
        taxPercentage: (data['taxPercentage'] as num?)?.toDouble() ?? 0.0,
        orderType: data['orderType'] as String? ?? 'takeaway',
        paymentMethod: data['paymentMethod'] as String? ?? 'cash',
        tableId: data['tableId'] as int?,
      );

      _webSocketHub.broadcast(
        WsEvents.orderCreated,
        {'transactionId': txnId},
        senderId: 'master',
      );

      return _jsonResponse({'id': txnId}, status: 201);
    } catch (e) {
      return _jsonResponse({'error': 'Failed to create order: $e'}, status: 500);
    }
  }

  /// GET /api/shift/active
  Future<Response> handleGetActiveShift(Request request) async {
    try {
      final activeShift = await _shiftDao.getAnyActiveShift();
      if (activeShift == null) {
        return _jsonResponse({'active': false});
      }
      return _jsonResponse({
        'active': true,
        'shift': activeShift.toJson(),
      });
    } catch (e) {
      return _jsonResponse({'error': 'Failed to fetch active shift: $e'}, status: 500);
    }
  }
}
