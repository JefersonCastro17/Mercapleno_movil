import 'dart:convert';

import 'package:mercapleno_appv1/features/auth/data/models/auth_session_model.dart';
import 'package:mercapleno_appv1/features/auth/domain/entities/auth_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {
  static const _tokenKey = 'mercapleno_auth_token';
  static const _userKey = 'mercapleno_auth_user';

  // Guarda solo lo minimo para reconstruir la sesion al reabrir la app.
  Future<void> saveSession(AuthSession session) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_tokenKey, session.token);
    final sessionModel = AuthSessionModel.fromEntity(session);
    await preferences.setString(_userKey, jsonEncode(sessionModel.user.toJson()));
  }

  // Lee token y usuario desde storage local y reconstruye la sesion.
  Future<AuthSession?> restoreSession() async {
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString(_tokenKey);
    final rawUser = preferences.getString(_userKey);

    if (token == null || rawUser == null) {
      return null;
    }

    try {
      final decodedUser = jsonDecode(rawUser);
      if (decodedUser is! Map<String, dynamic>) {
        await clear();
        return null;
      }

      return AuthSessionModel.fromJson(<String, dynamic>{
        'token': token,
        'user': decodedUser,
      }).toEntity();
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

