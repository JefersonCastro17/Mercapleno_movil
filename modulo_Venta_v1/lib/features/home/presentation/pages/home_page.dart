import 'package:flutter/material.dart';
import 'package:mercapleno_appv1/features/auth/presentation/controllers/auth_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.controller});

  final AuthController controller;

  String _welcomeRole() {
    final user = controller.session?.user;
    final roleLabel = user?.rol?.trim();
    if (roleLabel != null && roleLabel.isNotEmpty) return roleLabel;
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B4A8B),
        elevation: 0,
        title: const Text('Mercapleno', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _logout(context),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
                // TARJETA DE BIENVENIDA
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                          child: Icon(Icons.person, color: theme.colorScheme.primary, size: 30),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('¡Hola, $name!',
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0B4A8B))),
                              Text('Rol: $role', style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ACCESO AL MÓDULO DE VENTAS (NUEVO)
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/catalogo'),
                  child: Card(
                    color: theme.colorScheme.secondary, // Amarillo Mercapleno
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Row(
                        children: [
                          const Icon(Icons.shopping_basket_rounded, color: Colors.white, size: 40),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Módulo de Ventas',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                                Text('Realizar pedidos y gestionar carrito',
                                  style: TextStyle(color: Colors.white.withOpacity(0.9))),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // BOTÓN DE CERRAR SESIÓN
                TextButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.exit_to_app, color: Colors.red),
                  label: const Text('Cerrar sesión', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}