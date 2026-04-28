class AuthChallenge {
  const AuthChallenge({
    required this.pendingToken,
    required this.email,
    this.idRol,
    this.rol,
    this.expiresInMinutes,
  });

  final String pendingToken;
  final String email;
  final int? idRol;
  final String? rol;
  final int? expiresInMinutes;
}
