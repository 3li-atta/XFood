import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../device_config_service.dart';
import 'ws_events.dart';

/// Manages active client WebSocket connections on the Master server.
///
/// Responsible for:
/// - Registering connected clients
/// - Unregistering disconnected clients
/// - Broadcasting events to all clients
/// - Exposing a stream of incoming messages from clients to be processed
class WebSocketHub {
  final DeviceConfigService _config;
  final Set<WebSocketChannel> _clients = {};
  
  // Controller for broadcasting client messages upstream
  final StreamController<WsMessage> _messageStreamController = StreamController<WsMessage>.broadcast();

  WebSocketHub(this._config);

  /// Stream of all valid incoming messages from all connected clients.
  Stream<WsMessage> get incomingMessages => _messageStreamController.stream;

  /// The number of currently connected clients.
  int get clientCount => _clients.length;

  /// Register a newly connected client WebSocket channel.
  void addClient(WebSocketChannel channel) {
    _clients.add(channel);
    
    // Setup message listener
    channel.stream.listen(
      (rawData) {
        try {
          if (rawData is String) {
            final wsMessage = WsMessage.fromJsonString(rawData);
            
            // If it's a ping, respond directly with a pong
            if (wsMessage.event == WsEvents.ping) {
              final pong = WsMessage.create(
                event: WsEvents.pong,
                data: {},
                senderId: 'master',
              );
              channel.sink.add(pong.toJsonString());
            } else if (wsMessage.event == WsEvents.clientConnected) {
              // Handshake/Connection message from client: Validate pairing PIN
              final serverPin = _config.pairingPin;
              if (serverPin.isNotEmpty) {
                final clientPin = wsMessage.data['pairingPin'] as String?;
                if (clientPin != serverPin) {
                  final reject = WsMessage.create(
                    event: WsEvents.connectionRejected,
                    data: {'reason': 'رمز الاقتران غير صحيح (Invalid pairing PIN)'},
                    senderId: 'master',
                  );
                  channel.sink.add(reject.toJsonString());
                  _clients.remove(channel);
                  Future.delayed(const Duration(milliseconds: 500), () {
                    channel.sink.close();
                  });
                  return;
                }
              }
              
              // PIN is correct or no PIN configured. Now broadcast connection event.
              final deviceName = wsMessage.data['deviceName'] as String? ?? 'Generic Client';
              broadcast(
                WsEvents.clientConnected,
                {
                  'deviceName': deviceName,
                  'clientCount': clientCount,
                },
                senderId: 'master',
              );
            } else {
              _messageStreamController.add(wsMessage);
            }
          }
        } catch (e) {
          // Log parsing error or ignore invalid message structure
        }
      },
      onDone: () {
        removeClient(channel);
      },
      onError: (error) {
        removeClient(channel);
      },
      cancelOnError: true,
    );
  }

  /// Remove a client from the hub.
  void removeClient(WebSocketChannel channel) {
    if (_clients.remove(channel)) {
      try {
        channel.sink.close();
      } catch (_) {}

      // Broadcast disconnection event
      broadcast(
        WsEvents.clientDisconnected,
        {
          'clientCount': clientCount,
        },
        senderId: 'master',
      );
    }
  }

  /// Broadcast a WebSocket message to all currently connected clients.
  void broadcast(String event, Map<String, dynamic> data, {required String senderId}) {
    final message = WsMessage.create(
      event: event,
      data: data,
      senderId: senderId,
    );
    final rawJson = message.toJsonString();

    final List<WebSocketChannel> toRemove = [];
    for (final client in _clients) {
      try {
        client.sink.add(rawJson);
      } catch (e) {
        toRemove.add(client);
      }
    }

    // Clean up any failed connections
    for (final deadClient in toRemove) {
      removeClient(deadClient);
    }
  }

  /// Close all client connections and the stream controller.
  Future<void> dispose() async {
    final clientsCopy = List<WebSocketChannel>.from(_clients);
    for (final client in clientsCopy) {
      try {
        await client.sink.close();
      } catch (_) {}
    }
    _clients.clear();
    await _messageStreamController.close();
  }
}
