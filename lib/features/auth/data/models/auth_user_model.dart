import 'package:mercapleno_appv1/features/auth/domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.nombre,
    required super.apellido,
    required super.email,
    required super.idRol,
    required super.emailVerified,
    super.rol,
    super.tipoDocumento,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: _toInt(json['id']),
      nombre: json['nombre'] as String? ?? '',
      apellido: json['apellido'] as String? ?? '',
      email: json['email'] as String? ?? '',
      idRol: _toInt(json['id_rol']),
      emailVerified: json['email_verified'] as bool? ?? true,
      rol: json['rol'] as String?,
      tipoDocumento: json['tipo_documento'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'id_rol': idRol,
      'email_verified': emailVerified,
      'rol': rol,
      'tipo_documento': tipoDocumento,
    };
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }
}
