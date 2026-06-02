import '../../domain/entities/reportes_entities.dart';

class ResumenModel extends ResumenEntity {
  ResumenModel({required super.dineroTotal, required super.cantidadTotal, required super.promedio});

  factory ResumenModel.fromJson(Map<String, dynamic> json) => ResumenModel(
        dineroTotal: int.tryParse(json['dinero_total'].toString()) ?? 0,
        cantidadTotal: int.tryParse(json['total_ventas'].toString()) ?? 0,
        promedio: int.tryParse(json['promedio'].toString()) ?? 0,
      );
}

class VentaMesModel extends VentaMesEntity {
  VentaMesModel({required super.mes, required super.total});

  factory VentaMesModel.fromJson(Map<String, dynamic> json) => VentaMesModel(
        mes: json['mes'] ?? '',
        total: int.tryParse(json['total'].toString()) ?? 0,
      );
}

class TopProductoModel extends TopProductoEntity {
  TopProductoModel({required super.nombre, required super.totalVendido});

  factory TopProductoModel.fromJson(Map<String, dynamic> json) => TopProductoModel(
        nombre: json['nombre'] ?? '',
        totalVendido: int.tryParse(json['total_vendido'].toString()) ?? 0,
      );
}

class ResumenMesModel extends ResumenMesEntity {
  ResumenMesModel({required super.mes, required super.cantidadVentas, required super.totalMes});

  factory ResumenMesModel.fromJson(Map<String, dynamic> json) => ResumenMesModel(
        mes: json['mes'] ?? '',
        cantidadVentas: int.tryParse(json['cantidad_ventas'].toString()) ?? 0,
        totalMes: int.tryParse(json['total_mes'].toString()) ?? 0,
      );
}