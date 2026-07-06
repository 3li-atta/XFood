import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xfood_pos/core/services/device_config_service.dart';
import 'package:xfood_pos/core/services/lan_server_service.dart';
import 'package:xfood_pos/core/services/lan_sync/lan_client_service.dart';
import 'package:xfood_pos/core/services/lan_sync/api_handlers.dart';
import 'package:xfood_pos/core/services/lan_sync/api_router.dart';
import 'package:xfood_pos/core/services/lan_sync/websocket_hub.dart';
import 'package:xfood_pos/features/meals/data/repositories/remote_meal_repository.dart';
import 'package:xfood_pos/database/app_database.dart';
import 'package:xfood_pos/database/daos/meal_dao.dart';
import 'package:xfood_pos/database/daos/table_dao.dart';
import 'package:xfood_pos/database/daos/pending_order_dao.dart';
import 'package:xfood_pos/database/daos/transaction_dao.dart';
import 'package:xfood_pos/database/daos/shift_dao.dart';

void main() {
  late AppDatabase db;
  late DeviceConfigService deviceConfig;
  late WebSocketHub webSocketHub;
  late LanServerService lanServer;
  late ApiRouter apiRouter;
  
  const testPort = 8089;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'device_role': 'master',
      'device_name': 'Test POS Server',
    });

    db = AppDatabase.forTesting(NativeDatabase.memory());
    deviceConfig = DeviceConfigService();
    await deviceConfig.init();

    webSocketHub = WebSocketHub(deviceConfig);
    lanServer = LanServerService(webSocketHub);

    final handlers = ApiHandlers(
      mealDao: MealDao(db),
      tableDao: TableDao(db),
      pendingOrderDao: PendingOrderDao(db),
      transactionDao: TransactionDao(db),
      shiftDao: ShiftDao(db),
      deviceConfig: deviceConfig,
      webSocketHub: webSocketHub,
    );

    apiRouter = ApiRouter(handlers);

    // Start server
    await lanServer.start(apiRouter.router, port: testPort);
  });

  tearDown(() async {
    await lanServer.stop();
    await webSocketHub.dispose();
    await db.close();
  });

  group('LAN Sync Server Integration Tests', () {
    test('GET /api/health should return ok and device metadata', () async {
      final response = await http.get(Uri.parse('http://localhost:$testPort/api/health'));
      expect(response.statusCode, 200);

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      expect(data['status'], 'ok');
      expect(data['appName'], 'XFood POS');
      expect(data['deviceName'], 'Test POS Server');
      expect(data['role'], 'master');
    });

    test('GET /api/meals should return empty list initially', () async {
      final response = await http.get(Uri.parse('http://localhost:$testPort/api/meals'));
      expect(response.statusCode, 200);

      final data = jsonDecode(response.body) as List<dynamic>;
      expect(data, isEmpty);
    });

    test('GET /api/tables should return empty list initially', () async {
      final response = await http.get(Uri.parse('http://localhost:$testPort/api/tables'));
      expect(response.statusCode, 200);

      final data = jsonDecode(response.body) as List<dynamic>;
      expect(data, isEmpty);
    });

    test('RemoteMealRepository should fetch active meals from Master server', () async {
      // Seed a meal in database
      final mealDao = MealDao(db);
      await mealDao.insertMeal(const MealsCompanion(
        name: drift.Value('Tacos'),
        sellingPrice: drift.Value(5.99),
        category: drift.Value('Mexican'),
        isActive: drift.Value(true),
      ));

      // Setup client config to point to localhost:$testPort
      final clientConfig = DeviceConfigService();
      SharedPreferences.setMockInitialValues({
        'device_role': 'client',
        'master_ip': 'localhost',
        'master_port': testPort,
        'device_name': 'Test Waiter Tablet',
      });
      await clientConfig.init();

      final clientService = LanClientService(clientConfig);
      await clientService.connect();

      final remoteMealRepo = RemoteMealRepository(clientService);
      final meals = await remoteMealRepo.getActiveMeals();

      expect(meals, hasLength(1));
      expect(meals.first.name, 'Tacos');
      expect(meals.first.sellingPrice, 5.99);

      await clientService.disconnect();
    });

    test('LanClientService.testConnection() should return true when server is running', () async {
      final clientConfig = DeviceConfigService();
      SharedPreferences.setMockInitialValues({
        'device_role': 'client',
        'master_ip': 'localhost',
        'master_port': testPort,
        'device_name': 'Test Waiter Tablet',
      });
      await clientConfig.init();

      final clientService = LanClientService(clientConfig);
      final isHealthy = await clientService.testConnection();
      expect(isHealthy, isTrue);
    });

    test('LanClientService.testConnection() should return false when server is not reachable', () async {
      final clientConfig = DeviceConfigService();
      SharedPreferences.setMockInitialValues({
        'device_role': 'client',
        'master_ip': 'localhost',
        'master_port': 9999, // Unused port
        'device_name': 'Test Waiter Tablet',
      });
      await clientConfig.init();

      final clientService = LanClientService(clientConfig);
      final isHealthy = await clientService.testConnection();
      expect(isHealthy, isFalse);
    });

    test('WebSocket Handshake: connection rejected with invalid PIN', () async {
      // Set PIN on Master
      await deviceConfig.setPairingPin('5555');

      final clientConfig = DeviceConfigService();
      SharedPreferences.setMockInitialValues({
        'device_role': 'client',
        'master_ip': 'localhost',
        'master_port': testPort,
        'device_name': 'Test Waiter Tablet',
        'pairing_pin': '1111', // Wrong PIN
      });
      await clientConfig.init();

      final clientService = LanClientService(clientConfig);
      
      await clientService.connect();
      
      // Wait for handshake exchange and reject response
      await Future.delayed(const Duration(milliseconds: 600));

      expect(clientService.state, isNot(equals(LanConnectionState.connected)));

      await clientService.disconnect();
    });

    test('WebSocket Handshake: connection accepted with valid PIN', () async {
      // Set PIN on Master
      await deviceConfig.setPairingPin('5555');

      final clientConfig = DeviceConfigService();
      SharedPreferences.setMockInitialValues({
        'device_role': 'client',
        'master_ip': 'localhost',
        'master_port': testPort,
        'device_name': 'Test Waiter Tablet',
        'pairing_pin': '5555', // Correct PIN
      });
      await clientConfig.init();

      final clientService = LanClientService(clientConfig);
      
      await clientService.connect();
      
      // Wait for handshake exchange
      await Future.delayed(const Duration(milliseconds: 600));

      expect(clientService.state, equals(LanConnectionState.connected));

      await clientService.disconnect();
    });
  });
}
