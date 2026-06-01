import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

final _localAuth = LocalAuthentication();

class SecureStorage {
  SecureStorage._();

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Access token
  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessKey, value: token);
  }

  static Future<String?> readAccessToken() async {
    return await _storage.read(key: _accessKey);
  }

  /// Read access token but first require biometric/auth prompt when available.
  static Future<String?> readAccessTokenWithBiometrics({String reason = 'Authenticate to access token'}) async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported();
      if (canCheck) {
        final didAuth = await _localAuth.authenticate(
          localizedReason: reason,
          options: const AuthenticationOptions(biometricOnly: true),
        );
        if (!didAuth) return null;
      }
    } catch (_) {
      // If biometric fails/throws, fall back to no-auth read but calling code should handle nulls.
    }
    return await _storage.read(key: _accessKey);
  }

  static Future<void> deleteAccessToken() async {
    await _storage.delete(key: _accessKey);
  }

  // Refresh token
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshKey, value: token);
  }

  static Future<String?> readRefreshToken() async {
    return await _storage.read(key: _refreshKey);
  }

  /// Read refresh token after biometric auth when available.
  static Future<String?> readRefreshTokenWithBiometrics({String reason = 'Authenticate to access refresh token'}) async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported();
      if (canCheck) {
        final didAuth = await _localAuth.authenticate(
          localizedReason: reason,
          options: const AuthenticationOptions(biometricOnly: true),
        );
        if (!didAuth) return null;
      }
    } catch (_) {}
    return await _storage.read(key: _refreshKey);
  }

  static Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _refreshKey);
  }

  // Clear everything (use on logout)
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
