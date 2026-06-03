import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../domain/entities/product_entity.dart';
import '../models/product_model.dart';
import '../../../../core/config/app_config.dart';

class ProductRemoteDataSource {
  final http.Client client;
  String get baseUrl => "${AppConfig.apiBaseUrl}/api/productos";

  ProductRemoteDataSource(this.client);

  Map<String, String> _buildHeaders(String token) {
    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
    if (AppConfig.apiKey.isNotEmpty) {
      headers['x-api-key'] = AppConfig.apiKey;
    }
    return headers;
  }

  Future<List<ProductEntity>> fetchProducts(String token) async {
    final response = await client.get(
      Uri.parse(baseUrl),
      headers: _buildHeaders(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> decodedJson = json.decode(response.body);
      return decodedJson
          .map((item) => ProductModel.fromJson(item))
          .toList()
          .cast<ProductEntity>();
    } else {
      throw Exception('error al obtener los productos');
    }
  }

  Future<bool> uploadProductData({
    required String token,
    int? id,
    required Map<String, String> fields,
    File? imageFile,
  }) async {
    final uri = Uri.parse(id == null ? baseUrl : "$baseUrl/$id");
    final request = http.MultipartRequest(id == null ? 'POST' : 'PUT', uri);

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';
    if (AppConfig.apiKey.isNotEmpty) {
      request.headers['x-api-key'] = AppConfig.apiKey;
    }
    request.fields.addAll(fields);

    if (imageFile != null) {
      // Read bytes and force content-type to image/jpeg to satisfy backend
      final bytes = await imageFile.readAsBytes();
      // Force filename to have .jpg extension to satisfy backend filename checks
      final filename = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final multipartFile = http.MultipartFile.fromBytes(
        'imagen',
        bytes,
        filename: filename,
        contentType: MediaType('image', 'jpeg'),
      );
      // Log file info for debugging (filename, contentType, length)
      try {
        final length = bytes.length;
        print('[ProductRemoteDataSource] Attaching file: filename=${filename}, contentType=${multipartFile.contentType}, size=$length');
      } catch (_) {
        print('[ProductRemoteDataSource] Attaching file: filename=${filename}, contentType=${multipartFile.contentType}');
      }
      request.files.add(await multipartFile);
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }

    // Log detailed error for debugging and throw exception with server message.
    final body = response.body;
    // Print to console so it appears in flutter run logs.
    print('[ProductRemoteDataSource] Failed to save product. '
        'Status: ${response.statusCode}, Body: $body');
    throw Exception('HTTP ${response.statusCode}: $body');
  }

  Future<bool> removeProductFromApi(int id, String token) async {
    final response = await client.delete(
      Uri.parse("$baseUrl/$id"),
      headers: _buildHeaders(token),
    );

    final statusCode = response.statusCode;
    if (statusCode == 200 || statusCode == 202 || statusCode == 204) {
      return true;
    }

    print('[ProductRemoteDataSource] Failed to delete product. '
        'Status: $statusCode, Body: ${response.body}');

    String errorMsg = '';
    try {
      final decoded = json.decode(response.body);
      if (decoded is Map && decoded.containsKey('message')) {
        errorMsg = decoded['message'].toString();
      }
    } catch (_) {}

    final hasForeignKeyMsg = errorMsg.contains('Foreign key constraint violated') ||
        errorMsg.contains('foreign key') ||
        response.body.contains('Foreign key constraint violated') ||
        response.body.contains('foreign key');

    if (hasForeignKeyMsg) {
      throw Exception(
        'No se puede eliminar el producto porque está asociado a ventas, pedidos o inventarios registrados. '
        'En su lugar, te sugerimos editar el producto y cambiar su estado a "Agotado".'
      );
    }

    if (errorMsg.isNotEmpty) {
      throw Exception(errorMsg);
    }

    throw Exception('Error del servidor (código $statusCode).');
  }
}
