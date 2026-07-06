import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:xfood_pos/core/di/injection.dart';
import 'package:xfood_pos/core/services/device_config_service.dart';
import 'package:xfood_pos/core/services/lan_sync/lan_client_service.dart';
import '../app_database.dart';
import '../tables/tables_table.dart';

part 'table_dao.g.dart';

@DriftAccessor(tables: [Tables])
class TableDao extends DatabaseAccessor<AppDatabase> with _$TableDaoMixin {
  TableDao(super.db);

  bool get _isClientMode =>
      getIt.isRegistered<DeviceConfigService>() &&
      !getIt<DeviceConfigService>().isMaster &&
      getIt.isRegistered<LanClientService>();

  /// Insert a new table.
  Future<int> insertTable(TablesCompanion table) {
    return into(tables).insert(table);
  }

  /// Get all tables.
  Future<List<RestaurantTable>> getAllTables() async {
    if (_isClientMode) {
      try {
        final client = getIt<LanClientService>();
        final response = await client.get('/api/tables');
        if (response.statusCode == 200) {
          final List<dynamic> list = jsonDecode(response.body);
          return list.map((item) => RestaurantTable.fromJson(item as Map<String, dynamic>)).toList();
        }
      } catch (_) {}
      return [];
    }
    return select(tables).get();
  }

  /// Update the status of a table.
  Future<bool> updateTableStatus(int tableId, String status) async {
    if (_isClientMode) {
      try {
        final client = getIt<LanClientService>();
        final response = await client.put('/api/tables/$tableId/status', {'status': status});
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          return data['success'] as bool? ?? false;
        }
      } catch (_) {}
      return false;
    }
    return (update(tables)..where((t) => t.id.equals(tableId))).write(
      TablesCompanion(
        status: Value(status),
      ),
    ).then((rows) => rows > 0);
  }

  /// Get a table by id.
  Future<RestaurantTable?> getTableById(int id) async {
    if (_isClientMode) {
      try {
        final list = await getAllTables();
        return list.firstWhere((t) => t.id == id);
      } catch (_) {}
      return null;
    }
    return (select(tables)..where((t) => t.id.equals(id))).getSingleOrNull();
  }
}
