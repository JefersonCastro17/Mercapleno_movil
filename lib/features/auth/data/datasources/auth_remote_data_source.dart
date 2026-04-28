import 'package:mercapleno_appv1/core/config/app_config.dart';
import 'package:mercapleno_appv1/core/errors/api_exception.dart';
import 'package:mercapleno_appv1/core/network/api_client.dart';
import 'package:mercapleno_appv1/features/auth/data/models/auth_session_model.dart';
import 'package:mercapleno_appv1/features/auth/data/models/login_response_model.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      AppConfig.loginPath,
      body: <String, dynamic>{'email': email.trim(), 'password': password},
    );

    return LoginResponseModel.fromJson(response);
  }

  Future<AuthSessionModel> verifyLoginCode({
    required String pendingToken,
    required String code,
  }) async {
    final response = await _apiClient.post(
      AppConfig.verifyLoginCodePath,
      body: <String, dynamic>{
        'pendingToken': pendingToken,
        'code': code.trim(),
      },
    );

    final loginResponse = LoginResponseModel.fromJson(response);
    if (loginResponse.session == null) {
      throw ApiException(
        message: 'No se pudo completar el inicio de sesion.',
        statusCode: 500,
        data: response,
      );
    }

    return loginResponse.session!;
  }
}
