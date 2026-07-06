import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsd/nsd.dart' as nsd;
import 'package:xfood_pos/core/services/device_config_service.dart';
import 'package:xfood_pos/core/services/lan_server_service.dart';
import 'package:xfood_pos/core/services/lan_sync/lan_client_service.dart';
import 'package:xfood_pos/core/services/lan_sync/api_router.dart';
import 'package:xfood_pos/core/services/lan_sync/websocket_hub.dart';
import 'package:xfood_pos/core/services/lan_sync/ws_events.dart';
import 'package:xfood_pos/core/di/injection.dart';

// ── Events ──────────────────────────────────────────────────

abstract class DeviceSettingsEvent {}

class LoadDeviceSettings extends DeviceSettingsEvent {}

class UpdateDeviceRole extends DeviceSettingsEvent {
  final DeviceRole role;
  UpdateDeviceRole(this.role);
}

class UpdateDeviceName extends DeviceSettingsEvent {
  final String name;
  UpdateDeviceName(this.name);
}

class UpdateMasterAddress extends DeviceSettingsEvent {
  final String ip;
  final int port;
  UpdateMasterAddress(this.ip, this.port);
}

class UpdatePairingPin extends DeviceSettingsEvent {
  final String pin;
  UpdatePairingPin(this.pin);
}

class StartServerEvent extends DeviceSettingsEvent {}

class StopServerEvent extends DeviceSettingsEvent {}

class ConnectToMasterEvent extends DeviceSettingsEvent {}

class DisconnectFromMasterEvent extends DeviceSettingsEvent {}

class TestConnection extends DeviceSettingsEvent {}

class ClearMessages extends DeviceSettingsEvent {}

class StartDiscovery extends DeviceSettingsEvent {}

class StopDiscovery extends DeviceSettingsEvent {}

class DiscoveredServicesChanged extends DeviceSettingsEvent {
  final List<nsd.Service> services;
  DiscoveredServicesChanged(this.services);
}

class _ClientCountChanged extends DeviceSettingsEvent {
  final int clientCount;
  _ClientCountChanged(this.clientCount);
}

class _ConnectionStateChanged extends DeviceSettingsEvent {
  final LanConnectionState state;
  _ConnectionStateChanged(this.state);
}

class _ReconnectAttemptsChanged extends DeviceSettingsEvent {
  final int attempts;
  _ReconnectAttemptsChanged(this.attempts);
}

// ── State ───────────────────────────────────────────────────

class DeviceSettingsState {
  final DeviceRole role;
  final String deviceName;
  final String masterIp;
  final int masterPort;
  final String pairingPin;
  
  final bool isServerRunning;
  final String? serverIp;
  final int clientCount;
  
  final LanConnectionState connectionState;
  final List<nsd.Service> discoveredServices;
  
  final bool isLoading;
  final bool isTestingConnection;
  final String? errorMessage;
  final String? successMessage;
  final int reconnectAttempts;

  DeviceSettingsState({
    required this.role,
    required this.deviceName,
    required this.masterIp,
    required this.masterPort,
    required this.pairingPin,
    required this.isServerRunning,
    required this.serverIp,
    required this.clientCount,
    required this.connectionState,
    required this.discoveredServices,
    required this.isLoading,
    required this.isTestingConnection,
    this.errorMessage,
    this.successMessage,
    required this.reconnectAttempts,
  });

  factory DeviceSettingsState.initial() {
    return DeviceSettingsState(
      role: DeviceRole.master,
      deviceName: 'XFood POS',
      masterIp: '',
      masterPort: 8080,
      pairingPin: '',
      isServerRunning: false,
      serverIp: null,
      clientCount: 0,
      connectionState: LanConnectionState.disconnected,
      discoveredServices: const [],
      isLoading: false,
      isTestingConnection: false,
      reconnectAttempts: 0,
    );
  }

  DeviceSettingsState copyWith({
    DeviceRole? role,
    String? deviceName,
    String? masterIp,
    int? masterPort,
    String? pairingPin,
    bool? isServerRunning,
    String? serverIp,
    int? clientCount,
    LanConnectionState? connectionState,
    List<nsd.Service>? discoveredServices,
    bool clearError = false,
    bool clearSuccess = false,
    String? errorMessage,
    String? successMessage,
    bool? isLoading,
    bool? isTestingConnection,
    int? reconnectAttempts,
  }) {
    return DeviceSettingsState(
      role: role ?? this.role,
      deviceName: deviceName ?? this.deviceName,
      masterIp: masterIp ?? this.masterIp,
      masterPort: masterPort ?? this.masterPort,
      pairingPin: pairingPin ?? this.pairingPin,
      isServerRunning: isServerRunning ?? this.isServerRunning,
      serverIp: serverIp ?? this.serverIp,
      clientCount: clientCount ?? this.clientCount,
      connectionState: connectionState ?? this.connectionState,
      discoveredServices: discoveredServices ?? this.discoveredServices,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
      isLoading: isLoading ?? this.isLoading,
      isTestingConnection: isTestingConnection ?? this.isTestingConnection,
      reconnectAttempts: reconnectAttempts ?? this.reconnectAttempts,
    );
  }
}

// ── BLoC ────────────────────────────────────────────────────

class DeviceSettingsBloc extends Bloc<DeviceSettingsEvent, DeviceSettingsState> {
  final DeviceConfigService _config;
  final LanServerService _server;
  final LanClientService _client;
  final ApiRouter _apiRouter;
  final WebSocketHub _webSocketHub;

  StreamSubscription? _clientEventsSub;
  StreamSubscription? _connectionStateSub;
  StreamSubscription? _reconnectAttemptsSub;
  nsd.Discovery? _mdnsDiscovery;

  DeviceSettingsBloc({
    required DeviceConfigService config,
    required LanServerService server,
    required LanClientService client,
    required ApiRouter apiRouter,
    required WebSocketHub webSocketHub,
  })  : _config = config,
        _server = server,
        _client = client,
        _apiRouter = apiRouter,
        _webSocketHub = webSocketHub,
        super(DeviceSettingsState.initial()) {
    on<LoadDeviceSettings>(_onLoadSettings);
    on<UpdateDeviceRole>(_onUpdateRole);
    on<UpdateDeviceName>(_onUpdateName);
    on<UpdateMasterAddress>(_onUpdateMasterAddress);
    on<UpdatePairingPin>(_onUpdatePairingPin);
    on<StartServerEvent>(_onStartServer);
    on<StopServerEvent>(_onStopServer);
    on<ConnectToMasterEvent>(_onConnectToMaster);
    on<DisconnectFromMasterEvent>(_onDisconnectFromMaster);
    on<TestConnection>(_onTestConnection);
    on<ClearMessages>(_onClearMessages);
    on<StartDiscovery>(_onStartDiscovery);
    on<StopDiscovery>(_onStopDiscovery);
    on<DiscoveredServicesChanged>(_onDiscoveredServicesChanged);
    on<_ClientCountChanged>(_onClientCountChanged);
    on<_ConnectionStateChanged>(_onConnectionStateChanged);
    on<_ReconnectAttemptsChanged>(_onReconnectAttemptsChanged);

    // Stream listeners
    _connectionStateSub = _client.stateStream.listen((state) {
      add(_ConnectionStateChanged(state));
    });

    _reconnectAttemptsSub = _client.reconnectAttemptsStream.listen((attempts) {
      add(_ReconnectAttemptsChanged(attempts));
    });

    _clientEventsSub = _webSocketHub.incomingMessages.listen((msg) {
      if (msg.event == WsEvents.clientConnected || msg.event == WsEvents.clientDisconnected) {
        add(_ClientCountChanged(_webSocketHub.clientCount));
      }
    });
  }

  Future<void> _onLoadSettings(LoadDeviceSettings event, Emitter<DeviceSettingsState> emit) async {
    emit(state.copyWith(
      role: _config.role,
      deviceName: _config.deviceName,
      masterIp: _config.masterIp,
      masterPort: _config.masterPort,
      pairingPin: _config.pairingPin,
      isServerRunning: _server.isRunning,
      serverIp: _server.localIp,
      clientCount: _webSocketHub.clientCount,
      connectionState: _client.state,
      reconnectAttempts: _client.reconnectAttempts,
    ));

    if (_config.role != DeviceRole.master) {
      add(StartDiscovery());
    }
  }

  Future<void> _onUpdateRole(UpdateDeviceRole event, Emitter<DeviceSettingsState> emit) async {
    await _config.setRole(event.role);
    rebindRepositories();
    emit(state.copyWith(role: event.role));

    if (event.role == DeviceRole.master) {
      add(StopDiscovery());
    } else {
      add(StartDiscovery());
    }
  }

  Future<void> _onUpdateName(UpdateDeviceName event, Emitter<DeviceSettingsState> emit) async {
    await _config.setDeviceName(event.name);
    emit(state.copyWith(deviceName: event.name));
  }

  Future<void> _onUpdateMasterAddress(UpdateMasterAddress event, Emitter<DeviceSettingsState> emit) async {
    await _config.setMasterAddress(event.ip, event.port);
    emit(state.copyWith(masterIp: event.ip, masterPort: event.port));
  }

  Future<void> _onUpdatePairingPin(UpdatePairingPin event, Emitter<DeviceSettingsState> emit) async {
    await _config.setPairingPin(event.pin);
    emit(state.copyWith(pairingPin: event.pin));
  }

  Future<void> _onStartServer(StartServerEvent event, Emitter<DeviceSettingsState> emit) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      await _server.start(_apiRouter.router, port: state.masterPort);
      emit(state.copyWith(
        isServerRunning: _server.isRunning,
        serverIp: _server.localIp,
        successMessage: 'تم تشغيل الخادم المحلي بنجاح!',
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'فشل تشغيل الخادم: $e'));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onStopServer(StopServerEvent event, Emitter<DeviceSettingsState> emit) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      await _server.stop();
      emit(state.copyWith(
        isServerRunning: _server.isRunning,
        serverIp: null,
        clientCount: 0,
        successMessage: 'تم إيقاف الخادم المحلي بنجاح.',
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'فشل إيقاف الخادم: $e'));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onConnectToMaster(ConnectToMasterEvent event, Emitter<DeviceSettingsState> emit) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      final healthy = await _client.testConnection();
      if (!healthy) {
        emit(state.copyWith(
          errorMessage: 'لا يمكن الوصول للخادم الرئيسي. يرجى التأكد من تشغيل الخادم والاتصال بنفس الشبكة.',
          isLoading: false,
        ));
        return;
      }
      await _client.connect();
    } catch (e) {
      emit(state.copyWith(errorMessage: 'خطأ أثناء محاولة الاتصال: $e', isLoading: false));
    } finally {
      if (state.isLoading) {
        emit(state.copyWith(isLoading: false));
      }
    }
  }

  Future<void> _onDisconnectFromMaster(DisconnectFromMasterEvent event, Emitter<DeviceSettingsState> emit) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      await _client.disconnect();
      emit(state.copyWith(successMessage: 'تم قطع الاتصال بنجاح.'));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'خطأ أثناء قطع الاتصال: $e'));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onTestConnection(TestConnection event, Emitter<DeviceSettingsState> emit) async {
    emit(state.copyWith(isTestingConnection: true, clearError: true, clearSuccess: true));
    try {
      final success = await _client.testConnection();
      if (success) {
        emit(state.copyWith(successMessage: 'تم الاتصال بالخادم بنجاح!'));
      } else {
        emit(state.copyWith(errorMessage: 'فشل الاتصال بالخادم. يرجى التحقق من العنوان والشبكة.'));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: 'خطأ أثناء اختبار الاتصال: $e'));
    } finally {
      emit(state.copyWith(isTestingConnection: false));
    }
  }

  void _onClearMessages(ClearMessages event, Emitter<DeviceSettingsState> emit) {
    emit(state.copyWith(clearError: true, clearSuccess: true));
  }

  Future<void> _onStartDiscovery(StartDiscovery event, Emitter<DeviceSettingsState> emit) async {
    await _stopMdnsDiscovery();
    try {
      _mdnsDiscovery = await nsd.startDiscovery('_xfood-pos._tcp');
      _mdnsDiscovery!.addListener(() {
        if (!isClosed) {
          final List<nsd.Service> services = _mdnsDiscovery!.services.toList();
          add(DiscoveredServicesChanged(services));
        }
      });
    } catch (e) {
      print('mDNS Discovery failed: $e');
    }
  }

  Future<void> _onStopDiscovery(StopDiscovery event, Emitter<DeviceSettingsState> emit) async {
    await _stopMdnsDiscovery();
    emit(state.copyWith(discoveredServices: const []));
  }

  void _onDiscoveredServicesChanged(DiscoveredServicesChanged event, Emitter<DeviceSettingsState> emit) {
    emit(state.copyWith(discoveredServices: event.services));
  }

  Future<void> _stopMdnsDiscovery() async {
    if (_mdnsDiscovery != null) {
      try {
        await nsd.stopDiscovery(_mdnsDiscovery!);
      } catch (_) {}
      _mdnsDiscovery = null;
    }
  }

  void _onClientCountChanged(_ClientCountChanged event, Emitter<DeviceSettingsState> emit) {
    emit(state.copyWith(clientCount: event.clientCount));
  }

  void _onConnectionStateChanged(_ConnectionStateChanged event, Emitter<DeviceSettingsState> emit) {
    emit(state.copyWith(connectionState: event.state));
  }

  void _onReconnectAttemptsChanged(_ReconnectAttemptsChanged event, Emitter<DeviceSettingsState> emit) {
    emit(state.copyWith(reconnectAttempts: event.attempts));
  }

  @override
  Future<void> close() async {
    _clientEventsSub?.cancel();
    _connectionStateSub?.cancel();
    _reconnectAttemptsSub?.cancel();
    await _stopMdnsDiscovery();
    return super.close();
  }
}
