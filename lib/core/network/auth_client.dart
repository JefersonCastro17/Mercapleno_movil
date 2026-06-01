import 'dart:convert';

import 'package:http/http.dart' as http;
import '../storage/secure_storage.dart';

/// Simple authenticated client that injects `Authorization` header from secure storage
/// and attempts to refresh tokens on 401 responses.
class AuthClient {
  final http.Client _inner;
  final String? refreshUrl;

  /// [refreshUrl] should be an endpoint that accepts a POST with a JSON body
  /// containing { "refresh_token": "..." } and returns JSON with
  /// { "access_token": "...", "refresh_token": "..." } on success.
  AuthClient({http.Client? client, this.refreshUrl}) : _inner = client ?? http.Client();

  Future<http.Response> get(String url) async {
    return _withAuthRetry(() => _doGet(url));
  }

  Future<http.Response> post(String url, {Map<String, String>? headers, Object? body}) async {
    return _withAuthRetry(() => _doPost(url, headers: headers, body: body));
  }

  Future<http.Response> _doGet(String url) async {
    final token = await SecureStorage.readAccessToken();
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    return _inner.get(Uri.parse(url), headers: headers);
  }

  Future<http.Response> _doPost(String url, {Map<String, String>? headers, Object? body}) async {
    final token = await SecureStorage.readAccessToken();
    final merged = <String, String>{'Content-Type': 'application/json'};
    if (headers != null) merged.addAll(headers);
    if (token != null) merged['Authorization'] = 'Bearer $token';
    return _inner.post(Uri.parse(url), headers: merged, body: body);
  }

  Future<http.Response> _withAuthRetry(Future<http.Response> Function() requestFn) async {
    final res = await requestFn();
    if (res.statusCode != 401) return res;

    // Try refresh once
    final refreshed = await _tryRefreshToken();
    if (!refreshed) return res;

    // Retry original request once
    return await requestFn();
  }

  Future<bool> _tryRefreshToken() async {
    if (refreshUrl == null) return false;
    final refreshToken = await SecureStorage.readRefreshToken();
    if (refreshToken == null) return false;

    try {
      final resp = await _inner.post(
        Uri.parse(refreshUrl!),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      if (resp.statusCode != 200) return false;

      final Map<String, dynamic> body = jsonDecode(resp.body);
      final newAccess = body['access_token'] as String?;
      final newRefresh = body['refresh_token'] as String?;
      if (newAccess == null) return false;

      await SecureStorage.saveAccessToken(newAccess);
      if (newRefresh != null) await SecureStorage.saveRefreshToken(newRefresh);
      return true;
    } catch (_) {
      return false;
    }
  }

  void close() => _inner.close();
}
