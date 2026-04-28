import 'package:mercapleno_appv1/features/auth/domain/entities/auth_session.dart';
import 'package:mercapleno_appv1/features/auth/domain/repositories/auth_repository.dart';

class VerifyLoginCodeUseCase {
  const VerifyLoginCodeUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthSession> call({
    required String pendingToken,
    required String code,
  }) {
    return _repository.verifyLoginCode(pendingToken: pendingToken, code: code);
  }
}
