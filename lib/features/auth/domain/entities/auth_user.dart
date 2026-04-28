class AuthUser {
  const AuthUser({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.idRol,
    required this.emailVerified,
    this.rol,
    this.tipoDocumento,
  });

  final int id;
  final String nombre;
  final String apellido;
  final String email;
  final int idRol;
  final bool emailVerified;
  final String? rol;
  final String? tipoDocumento;

  String get fullName {
    final parts = [
      nombre.trim(),
      apellido.trim(),
    ].where((value) => value.isNotEmpty).toList();

    if (parts.isEmpty) {
      return email;
    }

    return parts.join(' ');
  }
}
