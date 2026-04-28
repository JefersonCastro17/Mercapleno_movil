import 'package:flutter/material.dart';
import 'package:mercapleno_appv1/app/app.dart';
import 'package:mercapleno_appv1/core/network/api_client.dart';
import 'package:mercapleno_appv1/core/storage/session_storage.dart';
import 'package:mercapleno_appv1/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mercapleno_appv1/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mercapleno_appv1/features/auth/domain/usecases/login_use_case.dart';
import 'package:mercapleno_appv1/features/auth/domain/usecases/logout_use_case.dart';
import 'package:mercapleno_appv1/features/auth/domain/usecases/restore_session_use_case.dart';
import 'package:mercapleno_appv1/features/auth/domain/usecases/verify_login_code_use_case.dart';
import 'package:mercapleno_appv1/features/auth/presentation/controllers/auth_controller.dart';

Future<AuthController> createAuthController() async {
  final repository = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSource(apiClient: ApiClient()),
    sessionStorage: SessionStorage(),
  );

  final controller = AuthController(
    loginUseCase: LoginUseCase(repository),
    verifyLoginCodeUseCase: VerifyLoginCodeUseCase(repository),
    restoreSessionUseCase: RestoreSessionUseCase(repository),
    logoutUseCase: LogoutUseCase(repository),
  );

  await controller.initialize();
  return controller;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authController = await createAuthController();
  runApp(MyApp(authController: authController));
}
