// modulo_G

import '../entities/product.dart';
import '../entities/product_movement.dart';

abstract class ProductsRepository {
  Future<List<Product>> getAllProducts();
  Future<List<ProductMovement>> getAllMovements();
  Future<void> createMovement({required String productId, required int quantity, required String type, String? note});
}
