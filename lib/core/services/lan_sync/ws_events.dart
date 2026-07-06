import 'dart:convert';

/// WebSocket event type constants used across the LAN sync protocol.
///
/// Both the Master server and Client devices reference these constants
/// to encode/decode the `event` field in [WsMessage] envelopes.
abstract class WsEvents {
  // ── Order lifecycle ──────────────────────────────────────────
  static const orderCreated = 'order_created';
  static const orderUpdated = 'order_updated';
  static const orderCancelled = 'order_cancelled';
  static const pendingOrderCreated = 'pending_order_created';
  static const pendingOrderDeleted = 'pending_order_deleted';

  // ── Menu sync ────────────────────────────────────────────────
  static const menuUpdated = 'menu_updated';
  static const mealAdded = 'meal_added';
  static const mealDeactivated = 'meal_deactivated';

  // ── Table management ─────────────────────────────────────────
  static const tableStatusChanged = 'table_status_changed';

  // ── Shift lifecycle ──────────────────────────────────────────
  static const shiftOpened = 'shift_opened';
  static const shiftClosed = 'shift_closed';

  // ── Connection lifecycle ─────────────────────────────────────
  static const clientConnected = 'client_connected';
  static const clientDisconnected = 'client_disconnected';
  static const connectionRejected = 'connection_rejected';

  // ── Heartbeat ────────────────────────────────────────────────
  static const ping = 'ping';
  static const pong = 'pong';
}

/// Standardized message envelope for all WebSocket communication.
///
/// Format:
/// ```json
/// {
///   "event": "order_created",
///   "data": { ... },
///   "timestamp": "2026-07-04T18:00:00.000Z",
///   "senderId": "Cashier-1"
/// }
/// ```
class WsMessage {
  /// Event type — one of [WsEvents] constants.
  final String event;

  /// Payload data specific to the event type.
  final Map<String, dynamic> data;

  /// ISO-8601 timestamp of when the message was created.
  final String timestamp;

  /// Identifier of the device that sent this message.
  final String senderId;

  const WsMessage({
    required this.event,
    required this.data,
    required this.timestamp,
    required this.senderId,
  });

  /// Create a new message with auto-generated timestamp.
  factory WsMessage.create({
    required String event,
    required Map<String, dynamic> data,
    required String senderId,
  }) {
    return WsMessage(
      event: event,
      data: data,
      timestamp: DateTime.now().toUtc().toIso8601String(),
      senderId: senderId,
    );
  }

  /// Deserialize from a JSON string received over WebSocket.
  factory WsMessage.fromJsonString(String raw) {
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return WsMessage(
      event: map['event'] as String,
      data: (map['data'] as Map<String, dynamic>?) ?? {},
      timestamp: map['timestamp'] as String? ?? '',
      senderId: map['senderId'] as String? ?? 'unknown',
    );
  }

  /// Serialize to a JSON string for sending over WebSocket.
  String toJsonString() {
    return jsonEncode({
      'event': event,
      'data': data,
      'timestamp': timestamp,
      'senderId': senderId,
    });
  }

  @override
  String toString() => 'WsMessage(event: $event, senderId: $senderId)';
}
