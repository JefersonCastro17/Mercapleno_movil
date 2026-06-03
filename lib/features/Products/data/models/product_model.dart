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
    double parsePrecio(dynamic value) {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        try {
          return double.parse(value);
        } catch (_) {
          return 0.0;
        }
      }
      return 0.0;
    }

    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) {
        try {
          return int.parse(value);
        } catch (_) {
          return 0;
        }
      }
      return 0;
    }

    return ProductModel(
      id: parseInt(json['id_productos']),
      nombre: json['nombre'] ?? '',
      precio: parsePrecio(json['precio']),
      idCategoria: parseInt(json['id_categoria']),
      idProveedor: parseInt(json['id_proveedor']),
      descripcion: json['descripcion'] ?? '',
      estado: json['estado'] ?? 'Disponible',
      imagen: json['imagen'] ?? '',
    );
  }
}
