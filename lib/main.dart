import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mercapleno_appv1/app/app.dart';
import 'package:mercapleno_appv1/core/network/api_client.dart';
import 'package:mercapleno_appv1/features/venta/presentation/providers/venta_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => VentaProvider()..loadCatalogo(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}