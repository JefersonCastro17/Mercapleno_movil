import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mercapleno_appv1/core/config/app_config.dart';
import 'package:mercapleno_appv1/core/errors/api_exception.dart';
import 'package:mercapleno_appv1/core/network/api_logger.dart';

class ApiClient {
  ApiClient({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  static const _timeout = Duration(seconds: 10);
  static const _getRetryCount = 1;
  static const _retryDelay = Duration(milliseconds: 350);

  // Se cambia a dynamic para soportar tanto Map como List (importante para el catálogo)
  Future<dynamic> get(
    String path, {
    Map<String, String>? queryParameters, // Nuevo parámetro para filtros
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path, queryParameters);
    ApiLogger.logRequest('GET', uri.toString());

    try {
      return await _executeRequest(
        () => _httpClient.get(uri, headers: _buildHeaders(headers)),
        method: 'GET',
        path: path,
        maxRetries: _getRetryCount,
      );
    } on http.ClientException {
      throw const ApiException(
        message: 'No se pudo conectar con el backend. Verifica que esté encendido.',
      );
    } on TimeoutException {
      throw const ApiException(
        message: 'El backend tardó demasiado en responder.',
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path);
    ApiLogger.logRequest('POST', uri.toString());

    try {
      // Mantenemos el retorno como Map<String, dynamic> para no romper Auth
      final result = await _executeRequest(
        () => _httpClient.post(
          uri,
          headers: _buildHeaders(headers),
          body: jsonEncode(body ?? <String, dynamic>{}),
        ),
        method: 'POST',
        path: path,
        maxRetries: 0,
      );
      return result as Map<String, dynamic>;
    } catch (error) {
      rethrow;
    }
  }

  // Soporte para adjuntar query params a la URL
  Uri _buildUri(String path, [Map<String, String>? queryParameters]) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final baseUrl = AppConfig.apiBaseUrl;
    final uri = Uri.parse('$baseUrl$normalizedPath');
    
    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(queryParameters: queryParameters);
    }
    return uri;
  }

  Future<dynamic> _executeRequest(
    Future<http.Response> Function() request, {
    required String method,
    required String path,
    required int maxRetries,
  }) async {
    var attempt = 0;

    while (true) {
      final startedAt = DateTime.now();

      try {
        final response = await request().timeout(_timeout);
        final duration = DateTime.now().difference(startedAt);

        ApiLogger.logResponse(
          method,
          path,
          response.statusCode,
          duration: duration,
        );

        return _handleResponse(response);
      } catch (error) {
        if (attempt >= maxRetries) rethrow;
        attempt += 1;
        await Future.delayed(_retryDelay);
      }
    }
  }

  Map<String, String> _buildHeaders(Map<String, String>? headers) {
    return <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      ...?headers,
    };
  }

  dynamic _handleResponse(http.Response response) {
    final data = _decodeBody(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    throw ApiException(
      message: data is Map ? (data['message'] ?? 'Error de solicitud') : 'Error desconocido',
      statusCode: response.statusCode,
      data: data is Map ? data as Map<String, dynamic> : null,
    );
  }

  dynamic _decodeBody(String body) {
    if (body.trim().isEmpty) return <String, dynamic>{};
    return jsonDecode(body);
  }
}