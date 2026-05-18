import 'package:flutter/material.dart';
import 'package:mercapleno_appv1/core/theme/app_theme.dart';
import 'package:mercapleno_appv1/features/venta/presentation/pages/catalogo_page.dart';
import 'package:mercapleno_appv1/features/venta/presentation/pages/carrito_page.dart';
import 'package:mercapleno_appv1/features/venta/presentation/pages/ticket_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mercapleno',
      theme: AppTheme.light(),
      home: const CatalogoPage(),
      routes: {
        '/catalogo': (context) => const CatalogoPage(),
        '/carrito': (context) => const CarritoPage(),
        '/ticket': (context) => const TicketPage(),
      },
    );
  }
}