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
    return into(users).insert(user);
  }

  /// Update a user's password hash.
  Future<bool> updatePassword(int userId, String newPasswordHash) {
    return (update(users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(
        passwordHash: Value(newPasswordHash),
        updatedAt: Value(DateTime.now()),
      ),
    ).then((rows) => rows > 0);
  }

  /// Update a user's password hash and clear mustChangePassword flag.
  Future<bool> updatePasswordAndClearForceFlag(int userId, String newPasswordHash) {
    return (update(users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(
        passwordHash: Value(newPasswordHash),
        mustChangePassword: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    ).then((rows) => rows > 0);
  }

  /// Update user details.
  Future<bool> updateUser(int userId, UsersCompanion companion) {
    return (update(users)..where((u) => u.id.equals(userId)))
        .write(companion)
        .then((rows) => rows > 0);
  }

  /// Delete a user by id.
  Future<int> deleteUser(int userId) {
    return (delete(users)..where((u) => u.id.equals(userId))).go();
  }
}
