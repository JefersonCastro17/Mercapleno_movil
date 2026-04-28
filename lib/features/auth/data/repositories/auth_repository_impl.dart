import 'package:mercapleno_appv1/core/storage/session_storage.dart';
import 'package:mercapleno_appv1/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mercapleno_appv1/features/auth/domain/entities/auth_session.dart';
import 'package:mercapleno_appv1/features/auth/domain/entities/login_result.dart';
import 'package:mercapleno_appv1/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SessionStorage sessionStorage,
  }) : _remoteDataSource = remoteDataSource,
       _sessionStorage = sessionStorage;

  final AuthRemoteDataSource _remoteDataSource;
  final SessionStorage _sessionStorage;

  @override
  Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    final response = await _remoteDataSource.login(
      email: email,
      password: password,
    );

    if (response.session != null) {
      await _sessionStorage.save(response.session!);
    }

    return response.toEntity();
  }

  @override
  Future<AuthSession> verifyLoginCode({
    required String pendingToken,
    required String code,
  }) async {
    final session = await _remoteDataSource.verifyLoginCode(
      pendingToken: pendingToken,
      code: code,
    );

    await _sessionStorage.save(session);
    return session;
  }

  @override
  Future<AuthSession?> restoreSession() {
    return _sessionStorage.read();
  }

  @override
  Future<void> logout() {
    return _sessionStorage.clear();
  }
}
