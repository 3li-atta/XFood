import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/recover_password_usecase.dart';
import '../../../../core/utils/session_manager.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Bloc managing authentication state.
///
/// Handles login, logout, and password recovery flows.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RecoverPasswordUseCase _recoverPasswordUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required RecoverPasswordUseCase recoverPasswordUseCase,
  })  : _loginUseCase = loginUseCase,
        _recoverPasswordUseCase = recoverPasswordUseCase,
        super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<PasswordRecoveryRequested>(_onPasswordRecoveryRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _loginUseCase(LoginParams(
        username: event.username,
        password: event.password,
      ));
      SessionManager.instance.setUser(user);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      SessionManager.instance.clear();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onPasswordRecoveryRequested(
    PasswordRecoveryRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _recoverPasswordUseCase(RecoverPasswordParams(
        recoveryEmail: event.recoveryEmail,
        newPassword: event.newPassword,
      ));
      emit(const PasswordRecoverySuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
