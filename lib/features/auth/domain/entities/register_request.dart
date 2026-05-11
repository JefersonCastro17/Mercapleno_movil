class RegisterRequest {
  const RegisterRequest({
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.password,
    required this.direccion,
    required this.fechaNacimiento,
    required this.idTipoIdentificacion,
    required this.numeroIdentificacion,
    this.idRol = 3,
  });

  final String nombre;
  final String apellido;
  final String email;
  final String password;
  final String direccion;
  final String fechaNacimiento;
  final int idTipoIdentificacion;
  final String numeroIdentificacion;
  final int idRol;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'password': password,
      'direccion': direccion,
      'fecha_nacimiento': fechaNacimiento,
      'id_rol': idRol,
      'id_tipo_identificacion': idTipoIdentificacion,
      'numero_identificacion': numeroIdentificacion,
    };
  }
}

