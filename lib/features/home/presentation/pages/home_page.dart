import 'package:flutter/material.dart';
import 'package:mercapleno_appv1/features/auth/presentation/controllers/auth_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.controller});

  final AuthController controller;

  String _welcomeRole() {
    final user = controller.session?.user;
    final roleLabel = user?.rol?.trim();
    if (roleLabel != null && roleLabel.isNotEmpty) {
      return roleLabel;
    }
    final idRol = user?.idRol;
    return idRol != null ? 'Rol $idRol' : 'Usuario';
  }

  String _displayName() {
    final user = controller.session?.user;
    final name = user?.fullName.trim();
    if (name != null && name.isNotEmpty) {
      final parts = name.split(' ');
      return parts.first;
    }
    return 'Usuario';
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await controller.logout();
    } catch (error) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('No se pudo cerrar sesión: ${error.toString()}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = _displayName();
    final role = _welcomeRole();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B4A8B),
        elevation: 0,
        title: const Text('Mercapleno'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _logout(context),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Bienvenido, $name!',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B4A8B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Rol: $role',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF3F5874),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Ya estás autenticado. Usa el botón de abajo para cerrar sesión cuando quieras salir.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4F647E),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => _logout(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF0B4A8B),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Cerrar sesión',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
