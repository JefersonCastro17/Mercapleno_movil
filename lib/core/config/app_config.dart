class AppConfig {
  AppConfig._();

  static const String _baseUrl = 'http://192.168.128.16:4000';

  static String get apiBaseUrl {
    const override = String.fromEnvironment('API_BASE_URL');
    if (override.isNotEmpty) {
      return _sanitizeBaseUrl(override);
    }
    return _sanitizeBaseUrl(_baseUrl);
  }

  // 🖼️ GESTIÓN DE IMÁGENES
  static String get uploadsUrl => '$apiBaseUrl/uploads';

  // 🔗 ENDPOINTS DE AUTENTICACIÓN
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

  // 🛒 MÓDULO DE VENTAS (Sincronizado con SalesController de NestJS)
  static String get _salesBasePath => '/api/sales';
  
  static String get getProductsEndpoint => '$_salesBasePath/products';
  static String get getCategoriesEndpoint => '$_salesBasePath/categories';
  static String get createOrderEndpoint => '$_salesBasePath/orders';

  // 🧹 LIMPIEZA DE URL
  static String _sanitizeBaseUrl(String value) {
    if (value.endsWith('/')) {
      return value.substring(0, value.length - 1);
    }
    return value;
  }
}
