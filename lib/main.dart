import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mercapleno_appv1/app/app.dart';
import 'package:mercapleno_appv1/core/network/api_client.dart';
import 'package:mercapleno_appv1/core/storage/session_storage.dart';

// Autenticación
import 'package:mercapleno_appv1/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mercapleno_appv1/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mercapleno_appv1/features/auth/presentation/controllers/auth_controller.dart';

<<<<<<< HEAD
// Arma manualmente las dependencias principales del modulo auth.
// Aqui aun no se usa un contenedor de inyeccion de dependencias.
=======
// Módulo de Venta
import 'package:mercapleno_appv1/features/venta/presentation/providers/venta_provider.dart';

/// Inicialización del controlador de autenticación (Capa Core/Auth)
>>>>>>> feature/sales
Future<AuthController> createAuthController() async {
  // Se inyecta el ApiClient que ahora es dinámico (soporta Map y List)
  final repository = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSource(apiClient: ApiClient()),
    sessionStorage: SessionStorage(),
  );

  final controller = AuthController(repository: repository);
<<<<<<< HEAD
  await controller.initialize(); //sesion antes
=======
  
  // Carga la sesión persistente (Token) antes de arrancar la UI
  // Esto evita que la app parpadee al decidir entre Login y Home
  await controller.initialize();
>>>>>>> feature/sales
  return controller;
}

Future<void> main() async {
<<<<<<< HEAD
  // Flutter debe estar listo antes de usar plugins como SharedPreferences.
=======
  // 1. Asegurar que los bindings de Flutter estén listos para llamadas asíncronas
>>>>>>> feature/sales
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializar lógica de autenticación (Carga de token)
  final authController = await createAuthController();
<<<<<<< HEAD
  runApp(MyApp(authController: authController));
}

=======

  runApp(
    MultiProvider(
      providers: [
        // Proveedor de Autenticación
        ChangeNotifierProvider.value(value: authController),

        // Proveedor de Ventas
        // Se usa ..cargarProductos() o ..loadCatalogo() dependiendo de cómo 
        // hayas nombrado el método en tu VentaProvider.
        ChangeNotifierProvider(
          create: (_) => VentaProvider()..loadCatalogo(),
        ),
      ],
      // MyApp recibe el authController para gestionar el flujo de navegación inicial
      child: MyApp(authController: authController),
    ),
  );
}
>>>>>>> feature/sales
