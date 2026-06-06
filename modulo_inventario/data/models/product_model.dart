// modulo_G

import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({required String id, required String name, String? sku}) : super(id: id, name: name, sku: sku);

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      sku: json['sku'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'sku': sku};
}
