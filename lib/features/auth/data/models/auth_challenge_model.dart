import 'package:mercapleno_appv1/features/auth/domain/entities/auth_challenge.dart';

class AuthChallengeModel extends AuthChallenge {
  const AuthChallengeModel({
    required super.pendingToken,
    required super.email,
    super.idRol,
    super.rol,
    super.expiresInMinutes,
  });

  factory AuthChallengeModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return AuthChallengeModel(
      pendingToken: json['pendingToken'] as String? ?? '',
      email: user['email'] as String? ?? '',
      idRol: _toNullableInt(user['id_rol']),
      rol: user['rol'] as String?,
      expiresInMinutes: _toNullableInt(json['twoFactorExpiresInMinutes']),
    );
  }

  static int? _toNullableInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }
}
