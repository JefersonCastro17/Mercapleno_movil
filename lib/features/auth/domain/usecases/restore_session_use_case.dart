import 'package:mercapleno_appv1/features/auth/domain/entities/auth_session.dart';
import 'package:mercapleno_appv1/features/auth/domain/repositories/auth_repository.dart';

class RestoreSessionUseCase {
  const RestoreSessionUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthSession?> call() {
    return _repository.restoreSession();
  }
}
