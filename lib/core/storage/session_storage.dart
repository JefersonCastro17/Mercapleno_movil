import 'dart:convert';

import 'package:mercapleno_appv1/features/auth/data/models/auth_session_model.dart';
import 'package:mercapleno_appv1/features/auth/data/models/auth_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  Future<void> save(AuthSessionModel session) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_tokenKey, session.token);
    await preferences.setString(_userKey, jsonEncode(session.user.toJson()));
  }

  Future<AuthSessionModel?> read() async {
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString(_tokenKey);
    final userJson = preferences.getString(_userKey);

    if (token == null || userJson == null) {
      await clear();
      return null;
    }

    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return AuthSessionModel(
        user: AuthUserModel.fromJson(userMap),
        token: token,
      );
    } catch (_) {
      await clear();
      return null;
    }
  }

  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_tokenKey);
    await preferences.remove(_userKey);
  }
}
