import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:nsd/nsd.dart' as nsd;
import 'package:xfood_pos/core/di/injection.dart';
import 'package:xfood_pos/core/services/device_config_service.dart';

import 'lan_sync/websocket_hub.dart';

/// Embedded server running inside the Master POS terminal.
///
/// Binds to [InternetAddress.anyIPv4] on a specified port (default 8080)
/// to handle REST API requests and upgrade WebSocket connections for LAN sync.
class LanServerService {
  final WebSocketHub _webSocketHub;
  final NetworkInfo _networkInfo = NetworkInfo();

  HttpServer? _server;
  bool _isRunning = false;
  String? _localIp;
  int _port = 8080;
  nsd.Registration? _mdnsRegistration;

  LanServerService(this._webSocketHub);

  /// Whether the server is actively running.
  bool get isRunning => _isRunning;

  /// Whether the server is running and has a bound address.
  bool get isReachable => _isRunning && _server != null && _localIp != null;

  /// The active local IP address the server is reachable at.
  String? get localIp => _localIp;

  /// The active port the server is listening on.
  int get port => _port;

  /// Start the embedded server.
  ///
  /// Takes a shelf [Handler] which acts as the router/API layer.
  Future<void> start(Handler apiHandler, {int port = 8080}) async {
    if (_isRunning) return;

    _port = port;

    // Detect the best available local IP
    _localIp = await _detectLocalIp();

    // Create main request handler merging REST API with WebSocket endpoint
    final cascade = Cascade()
        .add(_wsHandler())
        .add(apiHandler);

    final handler = const Pipeline()
        .addMiddleware(logRequests())
        .addHandler(cascade.handler);

    // Bind server to any IPv4 address (makes it reachable over LAN/WiFi/VPN)
    _server = await io.serve(handler, InternetAddress.anyIPv4, port);
    _isRunning = true;

    // Register mDNS Service for P2P Auto-Discovery
    try {
      if (getIt.isRegistered<DeviceConfigService>()) {
        final config = getIt<DeviceConfigService>();
        final deviceName = config.deviceName.isNotEmpty ? config.deviceName : 'XFood POS Cashier';

        _mdnsRegistration = await nsd.register(
          nsd.Service(
            name: deviceName,
            type: '_xfood-pos._tcp',
            port: port,
            txt: {
              'deviceName': utf8.encode(deviceName) as Uint8List,
              'ip': utf8.encode(_localIp ?? '0.0.0.0') as Uint8List,
              'port': utf8.encode(port.toString()) as Uint8List,
            },
          ),
        );
      }
    } catch (e) {
      print('mDNS Registration failed: $e');
    }
  }

  /// Stop the embedded server.
  Future<void> stop() async {
    if (!_isRunning) return;

    // Unregister mDNS Service
    if (_mdnsRegistration != null) {
      try {
        await nsd.unregister(_mdnsRegistration!);
      } catch (_) {}
      _mdnsRegistration = null;
    }

    await _server?.close(force: true);
    _server = null;
    _localIp = null;
    _isRunning = false;
  }

  /// Creates a handler to match WebSocket upgrades on the '/ws' path.
  Handler _wsHandler() {
    final router = Router();

    // Handle WebSocket upgrade at '/ws'
    router.get('/ws', webSocketHandler((WebSocketChannel socket) {
      _webSocketHub.addClient(socket);
    }));

    return router.call;
  }

  /// Detects the device's local network IP.
  ///
  /// Prioritizes the Wi-Fi IP from [NetworkInfo], falling back to listing
  /// available network interfaces (useful for Ethernet or Tailscale/VPN).
  Future<String?> _detectLocalIp() async {
    try {
      // 1. Try network_info_plus wifi IP
      final wifiIp = await _networkInfo.getWifiIP();
      if (wifiIp != null && wifiIp.isNotEmpty && wifiIp != '0.0.0.0') {
        return wifiIp;
      }

      // 2. Fallback: Scan network interfaces
      final interfaces = await NetworkInterface.list(
        includeLoopback: false,
        type: InternetAddressType.IPv4,
      );

      final sortedInterfaces = List<NetworkInterface>.from(interfaces);
      sortedInterfaces.sort((a, b) {
        final aName = a.name.toLowerCase();
        final bName = b.name.toLowerCase();
        
        // Penalize virtual/WSL/Docker/VMware interfaces
        final aIsVirtual = aName.contains('virtual') ||
            aName.contains('wsl') ||
            aName.contains('host-only') ||
            aName.contains('vbox') ||
            aName.contains('vmware') ||
            aName.contains('loopback') ||
            aName.contains('vethernet');
        final bIsVirtual = bName.contains('virtual') ||
            bName.contains('wsl') ||
            bName.contains('host-only') ||
            bName.contains('vbox') ||
            bName.contains('vmware') ||
            bName.contains('loopback') ||
            bName.contains('vethernet');

        if (aIsVirtual && !bIsVirtual) return 1;
        if (!aIsVirtual && bIsVirtual) return -1;

        // Prioritize Wi-Fi or Ethernet interfaces
        final aIsPreferred = aName.contains('wi-fi') ||
            aName.contains('wifi') ||
            aName.contains('ethernet') ||
            aName.contains('wlan') ||
            aName.contains('lan');
        final bIsPreferred = bName.contains('wi-fi') ||
            bName.contains('wifi') ||
            bName.contains('ethernet') ||
            bName.contains('wlan') ||
            bName.contains('lan');

        if (aIsPreferred && !bIsPreferred) return -1;
        if (!aIsPreferred && bIsPreferred) return 1;

        return a.name.compareTo(b.name);
      });

      for (final interface in sortedInterfaces) {
        for (final address in interface.addresses) {
          if (!address.isLoopback) {
            return address.address;
          }
        }
      }
    } catch (_) {
      // Fail silently, return null or fallback
    }
    return null;
  }
}
