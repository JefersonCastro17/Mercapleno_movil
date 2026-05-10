class AppConfig {
  AppConfig._();

  // 🔥 CAMBIA AQUÍ TU IP DEL PC
  static const String _baseUrl = 'http://192.168.101.20:4000';

  static String get apiBaseUrl {
    const override = String.fromEnvironment('API_BASE_URL');

    if (override.isNotEmpty) {
      return _sanitizeBaseUrl(override);
    }

    return _baseUrl;
  }

  // 🖼️ GESTIÓN DE IMÁGENES
  // Esta ruta es vital para que ProductoModel.urlImagenCompleta funcione.
  // NestJS sirve los archivos estáticos usualmente en la raíz /uploads
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
  
  // Endpoint para obtener catálogo (soporta query params: search, category, precioMin, precioMax)
  static String get getProductsEndpoint => '$_salesBasePath/products';
  
  // Endpoint para obtener las categorías disponibles (Usado en el FilterBottomSheet)
  static String get getCategoriesEndpoint => '$_salesBasePath/categories';
  
  // Endpoint para registrar la venta (CreateOrderDto)
  static String get createOrderEndpoint => '$_salesBasePath/orders';

  // 🧹 LIMPIEZA DE URL
  static String _sanitizeBaseUrl(String value) {
    if (value.endsWith('/')) {
      return value.substring(0, value.length - 1);
    }
    return value;
  }
}