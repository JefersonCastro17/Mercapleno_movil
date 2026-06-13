// modulo_G

import '../datasources/products_remote_data_source.dart';
import '../models/product_model.dart';
import '../models/product_movement_model.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_movement.dart';
import '../../domain/repositories/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  ProductsRepositoryImpl({required ProductsRemoteDataSource remote}) : _remote = remote;

  final ProductsRemoteDataSource _remote;

  @override
  Future<List<Product>> getAllProducts() async {
    final raw = await _remote.fetchProducts();
    return raw.map((m) => ProductModel.fromJson(m)).toList(growable: false);
  }

  @override
  Future<List<ProductMovement>> getAllMovements() async {
    final raw = await _remote.fetchMovements();
    return raw.map((m) => ProductMovementModel.fromJson(m)).toList(growable: false);
  }

  @override
  Future<void> createMovement({required String productId, required int quantity, required String type, String? note}) async {
    final payload = {
      'id_producto': int.tryParse(productId) ?? 0,
      'tipo_movimiento': type == 'in' ? 'ENTRADA' : 'SALIDA',
      'cantidad': quantity,
      'id_documento': 'D1', // Default valid document type, works because db init handles empty reference documents gracefully
      'comentario': note,
    };

    await _remote.createMovement(payload);
  }
}
