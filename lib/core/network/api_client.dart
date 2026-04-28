import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mercapleno_appv1/core/config/app_config.dart';
import 'package:mercapleno_appv1/core/errors/api_exception.dart';

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String> headers = const {},
  }) async {
    late final http.Response response;

    try {
      response = await _client
          .post(
            _buildUri(path),
            headers: <String, String>{
              'Content-Type': 'application/json',
              ...headers,
            },
            body: body == null ? null : jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw ApiException(
        message:
            'El backend tardo demasiado en responder. Verifica que este encendido en ${AppConfig.apiBaseUrl}.',
        statusCode: 408,
      );
    } on http.ClientException {
      throw ApiException(
        message:
            'No se pudo conectar con el backend en ${AppConfig.apiBaseUrl}. Si pruebas en celular fisico, usa --dart-define=API_BASE_URL=http://TU_IP:4000.',
        statusCode: 503,
      );
    }

    return _parseResponse(response);
  }

  Uri _buildUri(String path) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('${AppConfig.apiBaseUrl}$normalizedPath');
  }

  Map<String, dynamic> _parseResponse(http.Response response) {
    final bodyText = response.body.trim();
    final dynamic payload;

    if (bodyText.isEmpty) {
      payload = <String, dynamic>{};
    } else {
      try {
        payload = jsonDecode(bodyText);
      } on FormatException {
        throw ApiException(
          message:
              'El backend respondio con un formato invalido. Revisa que la URL ${AppConfig.apiBaseUrl} apunte al servidor correcto.',
          statusCode: response.statusCode,
          data: bodyText,
        );
      }
    }
    final data = payload is Map<String, dynamic>
        ? payload
        : <String, dynamic>{'data': payload};

    final isSuccessful =
        response.statusCode >= 200 && response.statusCode < 300;

    if (!isSuccessful) {
      throw ApiException(
        message: _extractErrorMessage(data, response.statusCode),
        statusCode: response.statusCode,
        data: data,
      );
    }

    return data;
  }

  String _extractErrorMessage(Map<String, dynamic> payload, int statusCode) {
    final message = payload['message'];
    final error = payload['error'];
    final details = payload['details'];

    if (message is String && message.isNotEmpty) {
      return message;
    }

    if (error is String && error.isNotEmpty) {
      return error;
    }

    if (details is String && details.isNotEmpty) {
      return details;
    }

    return 'HTTP $statusCode';
  }
}
