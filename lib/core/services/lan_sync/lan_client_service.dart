import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import '../device_config_service.dart';
import 'ws_events.dart';

/// Connection states for the Client device.
enum LanConnectionState {
  disconnected,
  connecting,
  connected,
  error,
}

/// Client-side manager for connection and communication with the Master POS Server.
///
/// Handles:
/// - REST requests (GET, POST, PUT, DELETE) forwarding to the Master Server.
/// - Persistent WebSocket connection for real-time events.
/// - Heartbeat ping-pong monitoring.
/// - Automatic connection retry with backoff.
class LanClientService {
  final DeviceConfigService _config;
  
  WebSocketChannel? _wsChannel;
  LanConnectionState _state = LanConnectionState.disconnected;
  
  final StreamController<LanConnectionState> _stateController = StreamController<LanConnectionState>.broadcast();
  final StreamController<WsMessage> _eventController = StreamController<WsMessage>.broadcast();
  final StreamController<int> _reconnectAttemptsController = StreamController<int>.broadcast();
  
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;
  Timer? _pongTimeoutTimer;
  int _reconnectAttempts = 0;
  bool _shouldReconnect = true;

  LanClientService(this._config);

  /// Current connection state of the client.
  LanConnectionState get state => _state;

  /// Stream of connection state changes.
  Stream<LanConnectionState> get stateStream => _stateController.stream;

  /// Stream of all real-time events received from the Master server.
  Stream<WsMessage> get events => _eventController.stream;

  /// Stream of reconnect attempt numbers.
  Stream<int> get reconnectAttemptsStream => _reconnectAttemptsController.stream;

  /// Current number of reconnect attempts made.
  int get reconnectAttempts => _reconnectAttempts;

  /// Connect to the configured Master Server.
  Future<void> connect() async {
    _shouldReconnect = true;
    _reconnectAttempts = 0;
    _reconnectAttemptsController.add(0);
    _updateState(LanConnectionState.connecting);
    await _establishWebSocket();
  }

  /// Disconnect from the Master Server.
  Future<void> disconnect() async {
    _shouldReconnect = false;
    _reconnectAttempts = 0;
    _reconnectAttemptsController.add(0);
    _reconnectTimer?.cancel();
    _heartbeatTimer?.cancel();
    _pongTimeoutTimer?.cancel();
    await _wsChannel?.sink.close();
    _wsChannel = null;
    _updateState(LanConnectionState.disconnected);
  }

  /// Test connection to the Master Server.
  Future<bool> testConnection() async {
    try {
      final uri = Uri.parse('${_config.masterBaseUrl}/api/health');
      final response = await http.get(uri).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['status'] == 'ok';
      }
    } catch (_) {}
    return false;
  }

  /// Sends a WebSocket message to the Master server.
  void sendWsMessage(String event, Map<String, dynamic> data) {
    if (_wsChannel == null) return;
    
    final message = WsMessage.create(
      event: event,
      data: data,
      senderId: _config.deviceName,
    );
    try {
      _wsChannel!.sink.add(message.toJsonString());
    } catch (_) {
      _handleDisconnect();
    }
  }

  // ── REST API wrappers ────────────────────────────────────────

  /// Helper to send GET requests to the Master server.
  Future<http.Response> get(String path) async {
    final uri = Uri.parse('${_config.masterBaseUrl}$path');
    return http.get(uri).timeout(const Duration(seconds: 5));
  }

  /// Helper to send POST requests to the Master server.
  Future<http.Response> post(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('${_config.masterBaseUrl}$path');
    return http.post(
      uri,
      headers: {'content-type': 'application/json; charset=utf-8'},
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 5));
  }

  /// Helper to send PUT requests to the Master server.
  Future<http.Response> put(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('${_config.masterBaseUrl}$path');
    return http.put(
      uri,
      headers: {'content-type': 'application/json; charset=utf-8'},
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 5));
  }

  /// Helper to send DELETE requests to the Master server.
  Future<http.Response> delete(String path) async {
    final uri = Uri.parse('${_config.masterBaseUrl}$path');
    return http.delete(uri).timeout(const Duration(seconds: 5));
  }

  // ── Connection internals ─────────────────────────────────────

  Future<void> _establishWebSocket() async {
    _reconnectTimer?.cancel();
    _heartbeatTimer?.cancel();
    _pongTimeoutTimer?.cancel();

    try {
      // Connect to WS endpoint on Master
      final wsUri = Uri.parse('${_config.masterWsUrl}');
      final channel = WebSocketChannel.connect(wsUri);
      _wsChannel = channel;

      // Wait until connection is fully established (timeout in 5 seconds if offline)
      await channel.ready.timeout(const Duration(seconds: 5));

      // Update state first so sendWsMessage doesn't filter it out
      _updateState(LanConnectionState.connected);
      _reconnectAttempts = 0;
      _reconnectAttemptsController.add(0);

      // Send handshake info (deviceName, pairingPin) immediately upon connecting
      sendWsMessage(WsEvents.clientConnected, {
        'deviceName': _config.deviceName,
        'pairingPin': _config.pairingPin,
      });

      // Start listening to messages
      channel.stream.listen(
        (rawData) {
          _resetHeartbeat();
          if (rawData is String) {
            try {
              final message = WsMessage.fromJsonString(rawData);
              if (message.event == WsEvents.connectionRejected) {
                _updateState(LanConnectionState.error);
                disconnect();
              } else if (message.event != WsEvents.pong) {
                _eventController.add(message);
              }
            } catch (_) {}
          }
        },
        onDone: () => _handleDisconnect(),
        onError: (_) => _handleDisconnect(),
        cancelOnError: true,
      );

      _resetHeartbeat();
    } catch (_) {
      _handleDisconnect();
    }
  }

  void _handleDisconnect() {
    _wsChannel = null;
    _heartbeatTimer?.cancel();
    _pongTimeoutTimer?.cancel();

    if (_shouldReconnect) {
      _updateState(LanConnectionState.connecting);
      _scheduleReconnect();
    } else {
      _updateState(LanConnectionState.disconnected);
    }
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    
    // Exponential backoff up to 30 seconds
    final delaySeconds = (1 << _reconnectAttempts).clamp(1, 30);
    _reconnectAttempts++;
    _reconnectAttemptsController.add(_reconnectAttempts);

    _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
      if (_shouldReconnect) {
        _establishWebSocket();
      }
    });
  }

  void _resetHeartbeat() {
    _heartbeatTimer?.cancel();
    _pongTimeoutTimer?.cancel();
    // Expect some traffic or ping-pong every 15 seconds, otherwise assume dead connection
    _heartbeatTimer = Timer(const Duration(seconds: 15), () {
      try {
        // Send a ping to check if connection is alive
        sendWsMessage(WsEvents.ping, {});
        // Expect pong within 5 seconds
        _pongTimeoutTimer = Timer(const Duration(seconds: 5), () {
          _handleDisconnect();
        });
      } catch (_) {
        _handleDisconnect();
      }
    });
  }

  void _updateState(LanConnectionState newState) {
    if (_state != newState) {
      _state = newState;
      _stateController.add(newState);
    }
  }

  /// Clean up resources on dispose.
  Future<void> dispose() async {
    await disconnect();
    await _stateController.close();
    await _eventController.close();
    await _reconnectAttemptsController.close();
  }
}
