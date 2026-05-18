import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/product_entity.dart';
import '../models/product_model.dart';

class ProductRemoteDataSource {
  final http.Client client;
  final String baseUrl = "";

  ProductRemoteDataSource(this.client);

  Future<List<ProductEntity>> fetchProducts(String token) async {
    final response = await client.get(
      Uri.parse(baseUrl),
      headers: {'Authorization': 'Bearer $token'},
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
    request.fields.addAll(fields);

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('imagen', imageFile.path),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> removeProductFromApi(int id, String token) async {
    final response = await client.delete(
      Uri.parse("$baseUrl/$id"),
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200;
  }
}
