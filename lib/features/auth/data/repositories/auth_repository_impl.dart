import 'package:drift/drift.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/password_hasher.dart';
import '../../../../database/app_database.dart';
import '../../../../database/daos/user_dao.dart';

/// Concrete implementation of [AuthRepository] using Drift DAOs.
class AuthRepositoryImpl implements AuthRepository {
  final UserDao _userDao;

  AuthRepositoryImpl(this._userDao);

  @override
  Future<UserEntity> login(String username, String password) async {
    final user = await _userDao.findByUsername(username);
    if (user == null) {
      throw const AuthenticationException('User not found');
    }

    if (!PasswordHasher.verify(password, user.passwordHash)) {
      throw const AuthenticationException('Invalid password');
    }

    final permissions = await _userDao.getPermissionsForUser(user.id);
    return _mapToEntity(user, permissions);
  }

  @override
  Future<UserEntity> createUser({
    required String username,
    required String password,
    required String recoveryEmail,
    required String role,
  }) async {
    // Check if username already exists
    final existing = await _userDao.findByUsername(username);
    if (existing != null) {
      throw const ValidationException('Username already exists');
    }

    final hashedPassword = PasswordHasher.hash(password);

    final id = await _userDao.insertUser(UsersCompanion.insert(
      username: username,
      passwordHash: hashedPassword,
      recoveryEmail: recoveryEmail,
      role: role,
    ));

    // Assign default permissions based on role
    final defaultPermissions = role == 'admin'
        ? ['make_sales', 'manage_shifts', 'manage_inventory', 'manage_meals', 'view_transactions', 'view_reports', 'manage_purchases', 'manage_treasury', 'manage_backup', 'void_refund_sale', 'apply_large_discount', 'manage_users']
        : ['make_sales', 'manage_shifts'];

    await _userDao.assignPermissions(id, defaultPermissions);

    final user = await _userDao.findByUsername(username);
    final permissions = await _userDao.getPermissionsForUser(user!.id);
    return _mapToEntity(user, permissions);
  }

  @override
  Future<bool> resetPassword(String recoveryEmail, String newPassword) async {
    final user = await _userDao.findByRecoveryEmail(recoveryEmail);
    if (user == null) {
      throw const NotFoundException('User', 'with that recovery email');
    }

    final hashedPassword = PasswordHasher.hash(newPassword);
    return _userDao.updatePassword(user.id, hashedPassword);
  }

  @override
  Future<List<UserEntity>> getAllUsers() async {
    final users = await _userDao.getAllUsers();
    final List<UserEntity> entities = [];
    for (final user in users) {
      final permissions = await _userDao.getPermissionsForUser(user.id);
      entities.add(_mapToEntity(user, permissions));
    }
    return entities;
  }

  @override
  Future<bool> updateUser(int userId, {String? username, String? role}) async {
    final companion = UsersCompanion(
      username: username != null ? Value(username) : const Value.absent(),
      role: role != null ? Value(role) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    );
    return _userDao.updateUser(userId, companion);
  }

  @override
  Future<bool> deleteUser(int userId) async {
    final result = await _userDao.deleteUser(userId);
    return result > 0;
  }

  @override
  Future<bool> changePasswordAndClearForceFlag(int userId, String newPassword) async {
    final hashedPassword = PasswordHasher.hash(newPassword);
    return _userDao.updatePasswordAndClearForceFlag(userId, hashedPassword);
  }

  @override
  Future<void> assignPermissions(int userId, List<String> permissions) async {
    await _userDao.assignPermissions(userId, permissions);
  }

  /// Map Drift-generated [User] row to pure [UserEntity].
  UserEntity _mapToEntity(User user, List<String> permissions) {
    return UserEntity(
      id: user.id,
      username: user.username,
      recoveryEmail: user.recoveryEmail,
      role: user.role,
      mustChangePassword: user.mustChangePassword,
      permissions: permissions,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }
}
