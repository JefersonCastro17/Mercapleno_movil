import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();

  static const String _baseUrl = 'http://192.168.1.14:4000';

  static String get apiBaseUrl {
    final envUrl = dotenv.env['API_BASE_URL'];

    if (envUrl != null && envUrl.isNotEmpty) {
      return _sanitizeBaseUrl(envUrl);
    }

    return _baseUrl;
  }

  static String get apiKey =>
      dotenv.env['INTERNAL_API_KEY'] ?? '';

  // Endpoints.
  static String get authBasePath => '/api/auth';

  static String get loginEndpoint => '$authBasePath/login';
  static String get verifyLoginCodeEndpoint => '$authBasePath/verify-login-code';
  static String get documentTypesEndpoint => '$authBasePath/document-types';
  static String get registerEndpoint => '$authBasePath/register';
  static String get verifyEmailEndpoint => '$authBasePath/verify-email';
  static String get resendVerificationEndpoint =>
      '$authBasePath/resend-verification';
  static String get requestPasswordResetEndpoint =>
      '$authBasePath/request-password-reset';
  static String get resetPasswordEndpoint => '$authBasePath/reset-password';

  static String _sanitizeBaseUrl(String value) {
    if (value.endsWith('/')) {
      return value.substring(0, value.length - 1);
    }
    return value;
  }
}