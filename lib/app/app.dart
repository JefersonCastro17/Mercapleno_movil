import 'package:flutter/material.dart';
import 'package:mercapleno_appv1/core/theme/app_theme.dart';
import 'package:mercapleno_appv1/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mercapleno_appv1/features/home/presentation/pages/home_page.dart';
import 'package:mercapleno_appv1/features/home/presentation/pages/landing_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.authController});

  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mercapleno',
      theme: AppTheme.light(),
      home: AnimatedBuilder(
        animation: authController,
        builder: (context, _) {
          if (authController.isInitializing) {
            return const _SplashPage();
          }

          if (authController.isAuthenticated) {
            return HomePage(controller: authController);
          }

          return LandingPage(controller: authController);
        },
      ),
    );
  }
}

class _SplashPage extends StatelessWidget {
  const _SplashPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B4A8B), Color(0xFF123C63), Color(0xFFF4F7FB)],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Color(0xFFF4A300)),
              SizedBox(height: 16),
              Text(
                'Cargando Mercapleno...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

