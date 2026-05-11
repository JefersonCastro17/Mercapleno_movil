class AppConfig {
  AppConfig._();

  // Cambia esta URL.
  static const String _baseUrl = 'http://192.168.1.13:4000';

  static String get apiBaseUrl {
    const override = String.fromEnvironment('API_BASE_URL');

    if (override.isNotEmpty) {
      return _sanitizeBaseUrl(override);
    }

    return _baseUrl;
  }

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
