import 'dart:convert';

<<<<<<< HEAD
<<<<<<< HEAD
import 'package:mercapleno_appv1/features/auth/data/models/auth_session_model.dart';
import 'package:mercapleno_appv1/features/auth/domain/entities/auth_session.dart';
=======
import 'package:mercapleno_appv1/features/auth/domain/entities/auth_session.dart';
import 'package:mercapleno_appv1/features/auth/domain/entities/auth_user.dart';
>>>>>>> feature/sales
=======
import 'package:mercapleno_appv1/features/auth/data/models/auth_session_model.dart';
import 'package:mercapleno_appv1/features/auth/domain/entities/auth_session.dart';
>>>>>>> feature/products
import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {
  static const _tokenKey = 'mercapleno_auth_token';
  static const _userKey = 'mercapleno_auth_user';

<<<<<<< HEAD
  // Guarda solo lo minimo para reconstruir la sesion al reabrir la app.
=======
>>>>>>> feature/sales
  Future<void> saveSession(AuthSession session) async {
    final preferences = await SharedPreferences.getInstance();
    final sessionJson = AuthSessionModel.fromEntity(session).toJson();

    await preferences.setString(_tokenKey, session.token);
<<<<<<< HEAD
    final sessionModel = AuthSessionModel.fromEntity(session);
    await preferences.setString(_userKey, jsonEncode(sessionModel.user.toJson()));
=======
    await preferences.setString(_userKey, jsonEncode(sessionJson['user']));
>>>>>>> feature/products
  }

<<<<<<< HEAD
  // Lee token y usuario desde storage local y reconstruye la sesion.
=======
>>>>>>> feature/sales
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

<<<<<<< HEAD
<<<<<<< HEAD
      return AuthSessionModel.fromJson(<String, dynamic>{
        'token': token,
        'user': decodedUser,
      }).toEntity();
=======
      return AuthSession(
        token: token,
        user: AuthUser.fromJson(decodedUser),
      );
>>>>>>> feature/sales
=======
      final sessionModel = AuthSessionModel.fromJson(<String, dynamic>{
        'token': token,
        'user': decodedUser,
      });

      return sessionModel.toEntity();
>>>>>>> feature/products
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

