import 'package:mercapleno_appv1/features/auth/domain/entities/auth_session.dart';
import 'package:mercapleno_appv1/features/auth/domain/entities/login_result.dart';

abstract class AuthRepository {
  Future<LoginResult> login({required String email, required String password});

  Future<AuthSession> verifyLoginCode({
    required String pendingToken,
    required String code,
  });

  Future<AuthSession?> restoreSession();

  Future<void> logout();
}
