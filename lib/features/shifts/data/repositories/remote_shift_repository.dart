import 'dart:async';
import 'dart:convert';
import 'package:xfood_pos/core/services/lan_sync/lan_client_service.dart';
import 'package:xfood_pos/core/services/lan_sync/ws_events.dart';
import 'package:xfood_pos/features/shifts/domain/entities/shift_entity.dart';
import 'package:xfood_pos/features/shifts/domain/repositories/shift_repository.dart';

/// Client-side implementation of [ShiftRepository] that delegates active shift checks
/// to the Master server via HTTP REST API.
class RemoteShiftRepository implements ShiftRepository {
  final LanClientService _client;

  RemoteShiftRepository(this._client);

  DateTime _parseDateTime(dynamic value) {
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    } else if (value is String) {
      return DateTime.parse(value);
    }
    return DateTime.now();
  }

  ShiftEntity _mapJsonToShiftEntity(Map<String, dynamic> json) {
    final cashierId = json['cashierId'] as int? ?? 0;
    return ShiftEntity(
      id: json['id'] as int? ?? 0,
      cashierId: cashierId,
      cashierName: json['cashierName'] as String? ?? 'Cashier #$cashierId',
      status: json['status'] as String? ?? 'open',
      startingCash: (json['startingCash'] as num?)?.toDouble() ?? 0.0,
      expectedClosingCash: (json['expectedClosingCash'] as num?)?.toDouble(),
      actualClosingCash: (json['actualClosingCash'] as num?)?.toDouble(),
      variance: (json['variance'] as num?)?.toDouble(),
      totalSales: (json['totalSales'] as num?)?.toDouble() ?? 0.0,
      totalPurchases: (json['totalPurchases'] as num?)?.toDouble() ?? 0.0,
      totalCashIn: (json['totalCashIn'] as num?)?.toDouble() ?? 0.0,
      totalCashOut: (json['totalCashOut'] as num?)?.toDouble() ?? 0.0,
      openedAt: _parseDateTime(json['openedAt']),
      closedAt: json['closedAt'] != null ? _parseDateTime(json['closedAt']) : null,
      notes: json['notes'] as String?,
    );
  }

  @override
  Future<ShiftEntity?> getActiveShift(int cashierId) async {
    try {
      final response = await _client.get('/api/shift/active');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['active'] == true && data['shift'] != null) {
          return _mapJsonToShiftEntity(data['shift'] as Map<String, dynamic>);
        }
      }
    } catch (_) {}
    return null;
  }

  @override
  Stream<ShiftEntity?> watchActiveShift(int cashierId) {
    final controller = StreamController<ShiftEntity?>.broadcast();

    Future<void> checkShift() async {
      try {
        final shift = await getActiveShift(cashierId);
        if (!controller.isClosed) {
          controller.add(shift);
        }
      } catch (_) {}
    }

    // Initial check
    checkShift();

    // Listen to WebSocket events or check periodically
    final timer = Timer.periodic(const Duration(seconds: 8), (_) => checkShift());
    
    final subscription = _client.events.listen((msg) {
      if (msg.event == WsEvents.shiftOpened || msg.event == WsEvents.shiftClosed) {
        checkShift();
      }
    });

    controller.onCancel = () {
      timer.cancel();
      subscription.cancel();
      controller.close();
    };

    return controller.stream;
  }

  @override
  Future<int> openShift({required int cashierId, required double startingCash}) {
    throw UnsupportedError('Shift management is only supported on the Master device.');
  }

  @override
  Future<void> closeShift({required int shiftId, required double actualClosingCash, String? notes}) {
    throw UnsupportedError('Shift management is only supported on the Master device.');
  }

  @override
  Future<List<ShiftEntity>> getShiftHistory() async {
    return [];
  }

  @override
  Future<ShiftEntity> getShiftById(int shiftId) {
    throw UnsupportedError('Shift detail retrieval by ID is only supported on the Master device.');
  }
}
