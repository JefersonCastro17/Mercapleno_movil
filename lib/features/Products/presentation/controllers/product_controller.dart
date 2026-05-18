import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../domain/entities/product_entity.dart';

class ProductController extends ChangeNotifier {
  final String baseUrl = "http://localhost:4000/productos"; // Ajusta según tu backend
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
      request.files.add(await http.MultipartFile.fromPath("imagen", imageFile.path));
    }

    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      await loadProducts(token);
    } else {
      throw Exception("Error al guardar producto");
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
