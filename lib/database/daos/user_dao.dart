import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/users_table.dart';

part 'user_dao.g.dart';

/// Data Access Object for user operations.
@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.db);

  /// Get all users.
  Future<List<User>> getAllUsers() => select(users).get();

  /// Find a user by username (for login).
  Future<User?> findByUsername(String username) {
    return (select(users)..where((u) => u.username.equals(username)))
        .getSingleOrNull();
  }

  /// Find a user by recovery email (for password reset).
  Future<User?> findByRecoveryEmail(String email) {
    return (select(users)..where((u) => u.recoveryEmail.equals(email)))
        .getSingleOrNull();
  }

  /// Insert a new user. Returns the auto-generated id.
  Future<int> insertUser(UsersCompanion user) {
    return transaction(() async {
      final id = await into(users).insert(user);
      await db.into(db.auditLogs).insert(
        AuditLogsCompanion.insert(
          userId: id,
          action: 'create_user',
          details: Value('{"createdUserId": $id, "username": "${user.username.value}"}'),
        ),
      );
      return id;
    });
  }

  /// Update a user's password hash.
  Future<bool> updatePassword(int userId, String newPasswordHash) {
    return transaction(() async {
      final success = await (update(users)..where((u) => u.id.equals(userId))).write(
        UsersCompanion(
          passwordHash: Value(newPasswordHash),
          updatedAt: Value(DateTime.now()),
        ),
      ).then((rows) => rows > 0);

      if (success) {
        await db.into(db.auditLogs).insert(
          AuditLogsCompanion.insert(
            userId: userId,
            action: 'change_password',
            details: Value('{"userId": $userId}'),
          ),
        );
      }
      return success;
    });
  }

  /// Update a user's password hash and clear mustChangePassword flag.
  Future<bool> updatePasswordAndClearForceFlag(int userId, String newPasswordHash) {
    return transaction(() async {
      final success = await (update(users)..where((u) => u.id.equals(userId))).write(
        UsersCompanion(
          passwordHash: Value(newPasswordHash),
          mustChangePassword: const Value(false),
          updatedAt: Value(DateTime.now()),
        ),
      ).then((rows) => rows > 0);

      if (success) {
        await db.into(db.auditLogs).insert(
          AuditLogsCompanion.insert(
            userId: userId,
            action: 'change_password_and_clear_force_flag',
            details: Value('{"userId": $userId}'),
          ),
        );
      }
      return success;
    });
  }

  /// Update user details.
  Future<bool> updateUser(int userId, UsersCompanion companion) {
    return (update(users)..where((u) => u.id.equals(userId)))
        .write(companion)
        .then((rows) => rows > 0);
  }

  /// Delete a user by id.
  Future<int> deleteUser(int userId) {
    return transaction(() async {
      final user = await (select(users)..where((u) => u.id.equals(userId))).getSingleOrNull();
      final rows = await (delete(users)..where((u) => u.id.equals(userId))).go();

      if (rows > 0 && user != null) {
        await db.into(db.auditLogs).insert(
          AuditLogsCompanion.insert(
            userId: userId,
            action: 'delete_user',
            details: Value('{"deletedUserId": $userId, "username": "${user.username}"}'),
          ),
        );
      }
      return rows;
    });
  }

  /// Get permissions for a user.
  Future<List<String>> getPermissionsForUser(int userId) async {
    final rows = await (db.select(db.userPermissions)
          ..where((p) => p.userId.equals(userId)))
        .get();
    return rows.map((r) => r.permission).toList();
  }

  /// Assign permissions to a user (replace existing).
  Future<void> assignPermissions(int userId, List<String> permissions) {
    return db.transaction(() async {
      // 1. Delete existing permissions
      await (db.delete(db.userPermissions)
            ..where((p) => p.userId.equals(userId)))
          .go();

      // 2. Insert new permissions
      for (final permission in permissions) {
        await db.into(db.userPermissions).insert(
          UserPermissionsCompanion.insert(
            userId: userId,
            permission: permission,
          ),
        );
      }
    });
  }
}
