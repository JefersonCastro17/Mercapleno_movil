class DocumentType {
  const DocumentType({
    required this.id,
    required this.nombre,
  });

  final int id;
  final String nombre;

  factory DocumentType.fromJson(Map<String, dynamic> json) {
    return DocumentType(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      nombre: json['nombre'] is String ? json['nombre'] as String : '',
    );
  }
}

