part of 'auth_bloc.dart';

/// States for the AuthBloc.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state — no auth action taken yet.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Authentication in progress.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Successfully authenticated.
class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// Authentication failed.
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// User logged out.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Password recovery succeeded.
class PasswordRecoverySuccess extends AuthState {
  const PasswordRecoverySuccess();
}
