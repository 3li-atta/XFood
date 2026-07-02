part of 'auth_bloc.dart';

/// Events for the AuthBloc.
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// User submitted login credentials.
class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  const LoginRequested({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

/// User requested password recovery.
class PasswordRecoveryRequested extends AuthEvent {
  final String recoveryEmail;
  final String newPassword;

  const PasswordRecoveryRequested({
    required this.recoveryEmail,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [recoveryEmail, newPassword];
}

/// User logged out.
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
