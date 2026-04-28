import 'package:mercapleno_appv1/features/auth/data/models/auth_challenge_model.dart';
import 'package:mercapleno_appv1/features/auth/data/models/auth_session_model.dart';
import 'package:mercapleno_appv1/features/auth/domain/entities/login_result.dart';

class LoginResponseModel {
  const LoginResponseModel({
    required this.message,
    this.session,
    this.challenge,
  });

  final String message;
  final AuthSessionModel? session;
  final AuthChallengeModel? challenge;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final requiresTwoFactor = json['requiresTwoFactor'] == true;
    final user = json['user'];
    final token = json['token'];

    return LoginResponseModel(
      message: json['message'] as String? ?? '',
      session:
          !requiresTwoFactor && user is Map<String, dynamic> && token is String
          ? AuthSessionModel.fromJson(<String, dynamic>{
              'user': user,
              'token': token,
            })
          : null,
      challenge: requiresTwoFactor ? AuthChallengeModel.fromJson(json) : null,
    );
  }

  LoginResult toEntity() {
    return LoginResult(
      message: message,
      session: session,
      challenge: challenge,
    );
  }
}
