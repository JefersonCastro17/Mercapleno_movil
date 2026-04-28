import 'package:flutter/material.dart';
import 'package:mercapleno_appv1/core/errors/api_exception.dart';
import 'package:mercapleno_appv1/features/auth/domain/entities/auth_challenge.dart';
import 'package:mercapleno_appv1/features/auth/domain/entities/auth_session.dart';
import 'package:mercapleno_appv1/features/auth/domain/usecases/login_use_case.dart';
import 'package:mercapleno_appv1/features/auth/domain/usecases/logout_use_case.dart';
import 'package:mercapleno_appv1/features/auth/domain/usecases/restore_session_use_case.dart';
import 'package:mercapleno_appv1/features/auth/domain/usecases/verify_login_code_use_case.dart';

enum AuthStep { credentials, twoFactor }

class AuthController extends ChangeNotifier {
  AuthController({
    required LoginUseCase loginUseCase,
    required VerifyLoginCodeUseCase verifyLoginCodeUseCase,
    required RestoreSessionUseCase restoreSessionUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _loginUseCase = loginUseCase,
       _verifyLoginCodeUseCase = verifyLoginCodeUseCase,
       _restoreSessionUseCase = restoreSessionUseCase,
       _logoutUseCase = logoutUseCase;

  final LoginUseCase _loginUseCase;
  final VerifyLoginCodeUseCase _verifyLoginCodeUseCase;
  final RestoreSessionUseCase _restoreSessionUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthSession? _session;
  AuthChallenge? _challenge;
  bool _isInitializing = true;
  bool _isSubmitting = false;
  String? _errorMessage;
  String? _infoMessage;

  AuthSession? get session => _session;
  AuthChallenge? get challenge => _challenge;
  bool get isInitializing => _isInitializing;
  bool get isSubmitting => _isSubmitting;
  bool get isAuthenticated => _session != null;
  String? get errorMessage => _errorMessage;
  String? get infoMessage => _infoMessage;
  AuthStep get currentStep =>
      _challenge == null ? AuthStep.credentials : AuthStep.twoFactor;

  Future<void> initialize() async {
    try {
      _session = await _restoreSessionUseCase();
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  Future<void> loginWithCredentials({
    required String email,
    required String password,
  }) async {
    _clearFeedback();
    _isSubmitting = true;
    notifyListeners();

    try {
      final result = await _loginUseCase(email: email, password: password);

      _infoMessage = result.message;

      if (result.requiresTwoFactor) {
        _challenge = result.challenge;
      } else {
        _challenge = null;
        _session = result.session;
      }
    } on ApiException catch (error) {
      _handleApiError(error);
    } catch (_) {
      _errorMessage = 'Ocurrio un error inesperado. Intenta nuevamente.';
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> verifyTwoFactorCode(String code) async {
    final activeChallenge = _challenge;
    if (activeChallenge == null) {
      _errorMessage =
          'La verificacion ya no esta activa. Inicia sesion otra vez.';
      notifyListeners();
      return;
    }

    _clearFeedback();
    _isSubmitting = true;
    notifyListeners();

    try {
      _session = await _verifyLoginCodeUseCase(
        pendingToken: activeChallenge.pendingToken,
        code: code,
      );
      _challenge = null;
      _infoMessage = 'Inicio de sesion exitoso.';
    } on ApiException catch (error) {
      if (error.statusCode == 400 || error.statusCode == 401) {
        _challenge = null;
        _infoMessage = 'La verificacion expiro. Vuelve a iniciar sesion.';
      }
      _errorMessage = error.message;
    } catch (_) {
      _errorMessage = 'Ocurrio un error inesperado. Intenta nuevamente.';
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void cancelTwoFactorFlow() {
    _challenge = null;
    _clearFeedback();
    notifyListeners();
  }

  Future<void> logout() async {
    await _logoutUseCase();
    _session = null;
    _challenge = null;
    _clearFeedback();
    notifyListeners();
  }

  void dismissMessages() {
    _clearFeedback();
    notifyListeners();
  }

  void _handleApiError(ApiException error) {
    final data = error.data;
    final errorCode = data is Map<String, dynamic> ? data['code'] : null;

    if (error.statusCode == 403 && errorCode == 'EMAIL_NOT_VERIFIED') {
      _errorMessage = 'Debes verificar tu correo antes de iniciar sesion.';
      return;
    }

    if (_challenge != null &&
        (error.statusCode == 400 || error.statusCode == 401)) {
      _challenge = null;
      _infoMessage = 'La verificacion ya no es valida. Inicia sesion de nuevo.';
    }

    _errorMessage = error.message;
  }

  void _clearFeedback() {
    _errorMessage = null;
    _infoMessage = null;
  }
}
