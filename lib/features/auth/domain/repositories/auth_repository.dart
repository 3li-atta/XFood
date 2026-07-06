import '../entities/user_entity.dart';

/// Abstract repository contract for authentication operations.
abstract class AuthRepository {
  /// Authenticate a user by username and password.
  /// Returns [UserEntity] on success, throws on failure.
  Future<UserEntity> login(String username, String password);

  /// Create a new user account (Admin only).
  Future<UserEntity> createUser({
    required String username,
    required String password,
    required String recoveryEmail,
    required String role,
  });

  /// Reset password using recovery email.
  Future<bool> resetPassword(String recoveryEmail, String newPassword);

  /// Get all users (Admin only).
  Future<List<UserEntity>> getAllUsers();

  /// Update user details.
  Future<bool> updateUser(int userId, {String? username, String? role});

  /// Delete a user (Admin only).
  Future<bool> deleteUser(int userId);

  /// Change password and clear the force-change flag (V-12).
  Future<bool> changePasswordAndClearForceFlag(int userId, String newPassword);

  /// Assign granular permissions to a user.
  Future<void> assignPermissions(int userId, List<String> permissions);
}
