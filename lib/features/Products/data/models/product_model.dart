import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.nombre,
    required super.precio,
    required super.idCategoria,
    required super.idProveedor,
    required super.descripcion,
    required super.estado,
    required super.imagen,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id_productos'] is String
          ? int.parse(json['id_productos'])
          : (json['id_productos'] ?? 0),
      nombre: json['nombre'] ?? '',
      precio: json['precio'] ?? 0,
      idCategoria: json['id_categoria'] ?? 0,
      idProveedor: json['id_proveedor'] ?? 0,
      descripcion: json['descripcion'] ?? '',
      estado: json['estado'] ?? 'Disponible',
      imagen: json['imagen'] ?? '',
    );
  }
}
