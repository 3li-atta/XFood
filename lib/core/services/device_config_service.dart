import 'package:shared_preferences/shared_preferences.dart';

/// Device role in the LAN sync network.
///
/// - [master]: This device runs the embedded server and owns the database.
/// - [client]: This device connects to a master over the LAN for POS operations.
/// - [kds]: Kitchen Display System — receives order events in real-time.
enum DeviceRole {
  master,
  client,
  kds;

  /// Parse from stored string, defaulting to [master].
  static DeviceRole fromString(String? value) {
    return DeviceRole.values.firstWhere(
      (r) => r.name == value,
      orElse: () => DeviceRole.master,
    );
  }
}

/// Persists device network configuration via [SharedPreferences].
///
/// Stores:
/// - Device role (master / client / kds)
/// - Master server IP address (for clients)
/// - Master server port (default 8080)
/// - Human-readable device name
/// - Pairing PIN for client authentication
class DeviceConfigService {
  static const _keyRole = 'device_role';
  static const _keyMasterIp = 'master_ip';
  static const _keyMasterPort = 'master_port';
  static const _keyDeviceName = 'device_name';
  static const _keyPairingPin = 'pairing_pin';

  static const int defaultPort = 8080;

  SharedPreferences? _prefs;

  /// Initialize the service by loading SharedPreferences.
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _p {
    assert(_prefs != null, 'DeviceConfigService.init() must be called first');
    return _prefs!;
  }

  // ── Device Role ──────────────────────────────────────────────

  /// Current device role. Defaults to [DeviceRole.master].
  DeviceRole get role => DeviceRole.fromString(_p.getString(_keyRole));

  /// Whether this device is configured as the master/server.
  bool get isMaster => role == DeviceRole.master;

  /// Whether this device is configured as a client.
  bool get isClient => role == DeviceRole.client;

  /// Whether this device is configured as a KDS.
  bool get isKds => role == DeviceRole.kds;

  /// Persist the device role.
  Future<void> setRole(DeviceRole value) async {
    await _p.setString(_keyRole, value.name);
  }

  // ── Master Address (for client/kds devices) ──────────────────

  /// IP address of the master server.
  String get masterIp => _p.getString(_keyMasterIp) ?? '';

  /// Port of the master server. Defaults to [defaultPort].
  int get masterPort => _p.getInt(_keyMasterPort) ?? defaultPort;

  /// Full base URL to reach the master server.
  String get masterBaseUrl => 'http://$masterIp:$masterPort';

  /// WebSocket URL to reach the master server.
  String get masterWsUrl => 'ws://$masterIp:$masterPort/ws';

  /// Persist the master server address.
  Future<void> setMasterAddress(String ip, int port) async {
    await _p.setString(_keyMasterIp, ip);
    await _p.setInt(_keyMasterPort, port);
  }

  // ── Device Name ───────────────────────────────────────────────

  /// Human-readable name for this device (e.g., "Waiter Tablet 1").
  String get deviceName => _p.getString(_keyDeviceName) ?? 'XFood Terminal';

  /// Persist the device name.
  Future<void> setDeviceName(String name) async {
    await _p.setString(_keyDeviceName, name);
  }

  // ── Pairing PIN ───────────────────────────────────────────────

  /// Shared secret PIN for client authentication. Empty = no auth.
  String get pairingPin => _p.getString(_keyPairingPin) ?? '';

  /// Persist the pairing PIN.
  Future<void> setPairingPin(String pin) async {
    await _p.setString(_keyPairingPin, pin);
  }

  /// Whether a pairing PIN is configured.
  bool get hasPairingPin => pairingPin.isNotEmpty;
}
