import 'package:mercapleno_appv1/features/auth/domain/entities/login_result.dart';
import 'package:mercapleno_appv1/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<LoginResult> call({required String email, required String password}) {
    return _repository.login(email: email, password: password);
  }
}
