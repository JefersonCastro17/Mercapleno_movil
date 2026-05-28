import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../core/config/app_config.dart';
import '../../domain/entities/product_entity.dart';
import 'package:http_parser/http_parser.dart';

class ProductController extends ChangeNotifier {
  String get baseUrl => "${AppConfig.apiBaseUrl}/api/productos";
  List<ProductEntity> products = [];
  bool isLoading = false;

  Future<void> loadProducts(String token) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        products = data.map((e) => ProductEntity.fromJson(e)).toList();
      } else {
        throw Exception("Error al cargar productos");
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveProduct({
    required String token,
    int? id,
    required Map<String, dynamic> fields,
    File? imageFile,
  }) async {
    final uri = id == null
        ? Uri.parse(baseUrl)
        : Uri.parse("$baseUrl/$id");

    final request = http.MultipartRequest(id == null ? "POST" : "PUT", uri)
      ..headers["Authorization"] = "Bearer $token";

    fields.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    if (imageFile != null) {
      request.files.add(
  await http.MultipartFile.fromPath(
    "imagen",
    imageFile.path,
    contentType: MediaType("image", "jpeg"), // o "png", según el archivo
  ),
);
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200 || response.statusCode == 201) {
      await loadProducts(token);
    } else {
      print("Error al guardar producto: Code ${response.statusCode}, Body: ${response.body}");
      throw Exception("Error al guardar producto: ${response.statusCode} - ${response.body}");
    }
  }

  Future<void> deleteProduct(int id, String token) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/$id"),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      products.removeWhere((p) => p.id == id);
      notifyListeners();
    } else {
      throw Exception("Error al eliminar producto");
    }
  }
}
