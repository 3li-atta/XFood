import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Params for the login use case.
class LoginParams {
  final String username;
  final String password;

  const LoginParams({required this.username, required this.password});
}

/// Authenticates a user by username and password.
class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  Future<UserEntity> call(LoginParams params) {
    return _repository.login(params.username, params.password);
  }
}
