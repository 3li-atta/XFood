import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/audit_logs_table.dart';

part 'audit_log_dao.g.dart';

@DriftAccessor(tables: [AuditLogs])
class AuditLogDao extends DatabaseAccessor<AppDatabase> with _$AuditLogDaoMixin {
  AuditLogDao(super.db);

  /// Insert an audit log entry.
  Future<int> insertLog({
    required int userId,
    required String action,
    String? details,
  }) {
    return into(auditLogs).insert(
      AuditLogsCompanion.insert(
        userId: userId,
        action: action,
        details: Value(details),
      ),
    );
  }

  /// Get all audit logs, newest first.
  Future<List<AuditLog>> getAllLogs() {
    return (select(auditLogs)
          ..orderBy([(al) => OrderingTerm.desc(al.createdAt)]))
        .get();
  }

  /// Get audit logs for a specific action.
  Future<List<AuditLog>> getLogsByAction(String action) {
    return (select(auditLogs)
          ..where((al) => al.action.equals(action))
          ..orderBy([(al) => OrderingTerm.desc(al.createdAt)]))
        .get();
  }

  /// Get audit logs for a specific user.
  Future<List<AuditLog>> getLogsByUser(int userId) {
    return (select(auditLogs)
          ..where((al) => al.userId.equals(userId))
          ..orderBy([(al) => OrderingTerm.desc(al.createdAt)]))
        .get();
  }
}
