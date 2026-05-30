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

  // GET se usa para lecturas y tiene un reintento simple.
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path);
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
        message:
            'No se pudo conectar con el backend. Verifica que este encendido.',
      );
    } on TimeoutException {
      throw const ApiException(
        message:
            'El backend tardo demasiado en responder. Verifica la conexion o la IP configurada.',
      );
    } on FormatException {
      throw const ApiException(
        message: 'El backend respondio con un formato invalido.',
      );
    } catch (error) {
      final rawMessage = error.toString();
      if (_looksLikeConnectionError(rawMessage)) {
        throw const ApiException(
          message:
              'No se pudo conectar con el backend. Verifica que este encendido.',
        );
      }

      throw const ApiException(
        message: 'Ocurrio un error inesperado. Intenta nuevamente.',
      );
    }
  }

  // POST se usa para enviar datos al backend en formato JSON.
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path);
    ApiLogger.logRequest('POST', uri.toString());

    try {
      return await _executeRequest(
        () => _httpClient.post(
          uri,
          headers: _buildHeaders(headers),
          body: jsonEncode(body ?? <String, dynamic>{}),
        ),
        method: 'POST',
        path: path,
        maxRetries: 0,
      );
    } on http.ClientException {
      throw const ApiException(
        message:
            'No se pudo conectar con el backend. Verifica que este encendido.',
      );
    } on TimeoutException {
      throw const ApiException(
        message:
            'El backend tardo demasiado en responder. Verifica la conexion o la IP configurada.',
      );
    } on FormatException {
      throw const ApiException(
        message: 'El backend respondio con un formato invalido.',
      );
    } catch (error) {
      final rawMessage = error.toString();
      if (_looksLikeConnectionError(rawMessage)) {
        throw const ApiException(
          message:
              'No se pudo conectar con el backend. Verifica que este encendido.',
        );
      }

      throw const ApiException(
        message: 'Ocurrio un error inesperado. Intenta nuevamente.',
      );
    }
  }

  // PATCH se usa para actualizaciones parciales en formato JSON.
  Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path);
    ApiLogger.logRequest('PATCH', uri.toString());

    try {
      return await _executeRequest(
        () => _httpClient.patch(
          uri,
          headers: _buildHeaders(headers),
          body: jsonEncode(body ?? <String, dynamic>{}),
        ),
        method: 'PATCH',
        path: path,
        maxRetries: 0,
      );
    } on http.ClientException {
      throw const ApiException(
        message:
            'No se pudo conectar con el backend. Verifica que este encendido.',
      );
    } on TimeoutException {
      throw const ApiException(
        message:
            'El backend tardo demasiado en responder. Verifica la conexion o la IP configurada.',
      );
    } on FormatException {
      throw const ApiException(
        message: 'El backend respondio con un formato invalido.',
      );
    } catch (error) {
      final rawMessage = error.toString();
      if (_looksLikeConnectionError(rawMessage)) {
        throw const ApiException(
          message:
              'No se pudo conectar con el backend. Verifica que este encendido.',
        );
      }

      throw const ApiException(
        message: 'Ocurrio un error inesperado. Intenta nuevamente.',
      );
    }
  }

  // PUT se usa para actualizaciones completas en formato JSON.
  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path);
    ApiLogger.logRequest('PUT', uri.toString());

    try {
      return await _executeRequest(
        () => _httpClient.put(
          uri,
          headers: _buildHeaders(headers),
          body: jsonEncode(body ?? <String, dynamic>{}),
        ),
        method: 'PUT',
        path: path,
        maxRetries: 0,
      );
    } on http.ClientException {
      throw const ApiException(
        message:
            'No se pudo conectar con el backend. Verifica que este encendido.',
      );
    } on TimeoutException {
      throw const ApiException(
        message:
            'El backend tardo demasiado en responder. Verifica la conexion o la IP configurada.',
      );
    } on FormatException {
      throw const ApiException(
        message: 'El backend respondio con un formato invalido.',
      );
    } catch (error) {
      final rawMessage = error.toString();
      if (_looksLikeConnectionError(rawMessage)) {
        throw const ApiException(
          message:
              'No se pudo conectar con el backend. Verifica que este encendido.',
        );
      }

      throw const ApiException(
        message: 'Ocurrio un error inesperado. Intenta nuevamente.',
      );
    }
  }

  // DELETE se usa para eliminar recursos en el backend.
  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path);
    ApiLogger.logRequest('DELETE', uri.toString());

    try {
      return await _executeRequest(
        () => _httpClient.delete(uri, headers: _buildHeaders(headers)),
        method: 'DELETE',
        path: path,
        maxRetries: 0,
      );
    } on http.ClientException {
      throw const ApiException(
        message:
            'No se pudo conectar con el backend. Verifica que este encendido.',
      );
    } on TimeoutException {
      throw const ApiException(
        message:
            'El backend tardo demasiado en responder. Verifica la conexion o la IP configurada.',
      );
    } on FormatException {
      throw const ApiException(
        message: 'El backend respondio con un formato invalido.',
      );
    } catch (error) {
      final rawMessage = error.toString();
      if (_looksLikeConnectionError(rawMessage)) {
        throw const ApiException(
          message:
              'No se pudo conectar con el backend. Verifica que este encendido.',
        );
      }

      throw const ApiException(
        message: 'Ocurrio un error inesperado. Intenta nuevamente.',
      );
    }
  }

  Uri _buildUri(String path) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('${AppConfig.apiBaseUrl}$normalizedPath');
  }

  // Punto central de timeout, logs, reintentos y manejo de errores.
  Future<Map<String, dynamic>> _executeRequest(
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
      } on ApiException catch (error) {
        ApiLogger.logError(method, path, 'Error ${error.statusCode}: ${error.message}');
        rethrow;
      } on TimeoutException catch (error) {
        if (attempt >= maxRetries) {
          ApiLogger.logError(method, path, 'Timeout: ${error.toString()}');
          rethrow;
        }

        attempt += 1;
        ApiLogger.logRetry(method, path, attempt, maxRetries);
        await Future.delayed(_retryDelay);
      } on http.ClientException catch (error) {
        if (attempt >= maxRetries) {
          ApiLogger.logError(method, path, 'ClientException: ${error.message}');
          rethrow;
        }

        attempt += 1;
        ApiLogger.logRetry(method, path, attempt, maxRetries);
        await Future.delayed(_retryDelay);
      } catch (error) {
        final rawMessage = error.toString();
        if (!_looksLikeConnectionError(rawMessage) || attempt >= maxRetries) {
          ApiLogger.logError(method, path, rawMessage);
          rethrow;
        }

        attempt += 1;
        ApiLogger.logRetry(method, path, attempt, maxRetries);
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

  Map<String, dynamic> _handleResponse(http.Response response) {
    final data = _decodeBody(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    throw ApiException(
      message: _extractMessage(
        data,
        fallback: 'La solicitud no pudo completarse.',
      ),
      statusCode: response.statusCode,
      data: data,
    );
  }

  // El proyecto intenta trabajar siempre con mapas.
  // Si el backend devolviera una lista u otro valor, se adapta aqui.
  Map<String, dynamic> _decodeBody(String body) {
    if (body.trim().isEmpty) {
      return <String, dynamic>{};
    }

    final decoded = jsonDecode(body);

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    if (decoded is Map) {
      return decoded.cast<String, dynamic>();
    }

    return <String, dynamic>{'data': decoded};
  }

  String _extractMessage(
    Map<String, dynamic> data, {
    required String fallback,
  }) {
    final message = data['message'];
    if (message is String && message.trim().isNotEmpty) {
      return message;
    }
    return fallback;
  }

  bool _looksLikeConnectionError(String rawMessage) {
    return rawMessage.contains('SocketException') ||
        rawMessage.contains('Connection refused') ||
        rawMessage.contains('Failed host lookup');
  }
}
