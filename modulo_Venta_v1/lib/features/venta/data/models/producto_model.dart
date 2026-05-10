import 'package:mercapleno_appv1/core/config/app_config.dart';

class ProductoModel {
  final String id;
  final String nombre;
  final String descripcion; 
  final double precio; 
  final String imagen; 
  final String categoria; 
  int cantidad;

  ProductoModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagen,
    required this.categoria,
    this.cantidad = 1,
  });

  double get subtotal => precio * cantidad;
  double get impuesto => subtotal * 0.19; 
  double get totalConImpuesto => subtotal + impuesto;

  String get urlImagenCompleta {
    if (imagen.isEmpty) return 'https://via.placeholder.com/150';
    if (imagen.startsWith('http')) return imagen;
    final cleanPath = imagen.replaceAll(RegExp(r'^\.?\/'), '');
    return '${AppConfig.apiBaseUrl}/uploads/$cleanPath';
  }

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      id: (json['id'] ?? json['id_producto'])?.toString() ?? '',
      nombre: json['nombre'] ?? json['nombre_producto'] ?? 'Sin nombre',
      descripcion: json['descripcion'] ?? json['desc_producto'] ?? 'Sin descripción disponible',
      precio: (json['price'] ?? json['precio'] as num?)?.toDouble() ?? 0.0,
      imagen: json['image'] ?? json['imagen'] ?? '',
      categoria: json['category'] ?? json['categoria'] ?? 'General',
    );
  }

  // Estructura para el DTO que espera NestJS en SalesService
  Map<String, dynamic> toOrderItemJson() => {
    'id_producto': id,     // El backend busca item.id_producto
    'cantidad': cantidad,   // El backend busca item.cantidad
    'precio': precio,       // El backend busca item.precio
  };
}