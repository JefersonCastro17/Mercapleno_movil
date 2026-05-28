import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mercapleno_appv1/app/app.dart';
import 'package:mercapleno_appv1/core/network/api_client.dart';
import 'package:mercapleno_appv1/core/storage/session_storage.dart';

// Autenticación
import 'package:mercapleno_appv1/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mercapleno_appv1/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mercapleno_appv1/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mercapleno_appv1/features/venta/presentation/providers/venta_provider.dart';

Future<AuthController> createAuthController() async {
  final repository = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSource(apiClient: ApiClient()),
    sessionStorage: SessionStorage(),
  );

  final controller = AuthController(repository: repository);
  await controller.initialize();
  return controller;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authController = await createAuthController();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authController),
        ChangeNotifierProvider(
          create: (_) => VentaProvider()..loadCatalogo(),
        ),
      ],
      child: MyApp(authController: authController),
    ),
  );
}
