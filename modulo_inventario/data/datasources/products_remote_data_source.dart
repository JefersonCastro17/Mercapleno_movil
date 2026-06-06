// modulo_G

import '../../core/network/api_client.dart';

class ProductsRemoteDataSource {
  ProductsRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final data = await _apiClient.get('/api/products');
    if (data.containsKey('data') && data['data'] is List) {
      return List<Map<String, dynamic>>.from(data['data']);
    }
    if (data.containsKey('products') && data['products'] is List) {
      return List<Map<String, dynamic>>.from(data['products']);
    }
    return <Map<String, dynamic>>[];
  }

  Future<List<Map<String, dynamic>>> fetchMovements() async {
    final data = await _apiClient.get('/api/products/movements');
    if (data.containsKey('data') && data['data'] is List) {
      return List<Map<String, dynamic>>.from(data['data']);
    }
    if (data.containsKey('movements') && data['movements'] is List) {
      return List<Map<String, dynamic>>.from(data['movements']);
    }
    return <Map<String, dynamic>>[];
  }

  Future<Map<String, dynamic>> createMovement(Map<String, dynamic> payload) async {
    return await _apiClient.post('/api/products/movements', body: payload);
  }
}
