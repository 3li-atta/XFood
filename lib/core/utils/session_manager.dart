import '../../features/auth/domain/entities/user_entity.dart';

/// Global session manager that holds the current logged-in user.
///
/// Used across the app to access user info (id, role) without
/// re-querying or passing through every widget constructor.
class SessionManager {
  SessionManager._();
  static final SessionManager instance = SessionManager._();

  UserEntity? _currentUser;

  /// The currently logged-in user, or null if not authenticated.
  UserEntity? get currentUser => _currentUser;

  /// Convenience getter for the current user's ID.
  /// Returns -1 if no user is logged in (should never happen in guarded routes).
  int get currentUserId => _currentUser?.id ?? -1;

  /// Whether the current user is an admin.
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  /// Whether the current user is a cashier.
  bool get isCashier => _currentUser?.isCashier ?? false;

  /// Whether a user is currently logged in.
  bool get isLoggedIn => _currentUser != null;

  /// Check if the current user has a specific permission.
  bool hasPermission(String permission) {
    if (isAdmin) return true; // Admin has all permissions by default
    return _currentUser?.permissions.contains(permission) ?? false;
  }

  /// Store the user after successful login.
  void setUser(UserEntity user) {
    _currentUser = user;
  }

  /// Clear the session on logout.
  void clear() {
    _currentUser = null;
  }
}
