import 'package:equatable/equatable.dart';

/// Pure domain entity for a User — no database dependencies.
class UserEntity extends Equatable {
  final int id;
  final String username;
  final String recoveryEmail;
  final String role;
  final bool mustChangePassword;
  final List<String> permissions;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    required this.id,
    required this.username,
    required this.recoveryEmail,
    required this.role,
    required this.mustChangePassword,
    required this.permissions,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isAdmin => role == 'admin';
  bool get isCashier => role == 'cashier';

  @override
  List<Object?> get props =>
      [id, username, recoveryEmail, role, mustChangePassword, permissions, createdAt, updatedAt];
}
