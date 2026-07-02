import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// Params for password recovery.
class RecoverPasswordParams {
  final String recoveryEmail;
  final String newPassword;

  const RecoverPasswordParams({
    required this.recoveryEmail,
    required this.newPassword,
  });
}

/// Resets a user's password using their recovery email.
class RecoverPasswordUseCase
    implements UseCase<bool, RecoverPasswordParams> {
  final AuthRepository _repository;

  RecoverPasswordUseCase(this._repository);

  @override
  Future<bool> call(RecoverPasswordParams params) {
    return _repository.resetPassword(params.recoveryEmail, params.newPassword);
  }
}
