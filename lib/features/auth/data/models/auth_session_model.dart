import 'package:mercapleno_appv1/features/auth/data/models/auth_user_model.dart';
import 'package:mercapleno_appv1/features/auth/domain/entities/auth_session.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({
    required AuthUserModel super.user,
    required super.token,
  });

  @override
  AuthUserModel get user => super.user as AuthUserModel;

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      user: AuthUserModel.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String? ?? '',
    );
  }
}
