import 'package:flutter/foundation.dart';

class AppConfig {
  AppConfig._();

  static const String _fallbackDesktopUrl = 'http://localhost:4000';
  static const String _androidEmulatorUrl = 'http://10.0.2.2:4000';
  static const String authBasePath = '/api/auth';
  static const String loginPath = '$authBasePath/login';
  static const String verifyLoginCodePath = '$authBasePath/verify-login-code';

  static String get apiBaseUrl {
    const customBaseUrl = String.fromEnvironment('API_BASE_URL');
    if (customBaseUrl.isNotEmpty) {
      return customBaseUrl;
    }

    if (kIsWeb) {
      return _fallbackDesktopUrl;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return _androidEmulatorUrl;
    }

    return _fallbackDesktopUrl;
  }
}
