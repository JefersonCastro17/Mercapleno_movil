import 'package:flutter/material.dart';
import 'package:mercapleno_appv1/app/app.dart';
import 'package:mercapleno_appv1/core/network/api_client.dart';
import 'package:mercapleno_appv1/core/storage/session_storage.dart';
import 'package:mercapleno_appv1/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mercapleno_appv1/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mercapleno_appv1/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mercapleno_appv1/features/users_admin/data/datasources/users_admin_remote_data_source.dart';
import 'package:mercapleno_appv1/features/users_admin/data/repositories/users_admin_repository_impl.dart';
import 'package:mercapleno_appv1/features/users_admin/presentation/controllers/users_admin_controller.dart';

Future<void> main() async {
  // Flutter debe estar listo antes de usar plugins como SharedPreferences.
  WidgetsFlutterBinding.ensureInitialized();

  final apiClient = ApiClient();

  // Módulo Auth.
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSource(apiClient: apiClient),
    sessionStorage: SessionStorage(),
  );
  final authController = AuthController(repository: authRepository);
  await authController.initialize(); // sesion antes

  // Módulo Users Admin.
  final usersRepository = UsersAdminRepositoryImpl(
    remoteDataSource: UsersAdminRemoteDataSource(apiClient: apiClient),
  );
  final usersController = UsersAdminController(repository: usersRepository);

  runApp(MyApp(
    authController: authController,
    usersAdminController: usersController,
  ));
}

