import 'package:flutter/material.dart';
import 'package:mercapleno_appv1/features/auth/presentation/controllers/auth_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.controller});

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    final session = controller.session;
    final user = session?.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mercapleno'),
        backgroundColor: const Color(0xFF0B5CAD),
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF4F7FB), Color(0xFFE9F0F8)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF103A61),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bienvenido, ${user?.fullName ?? 'usuario'}',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'El login ya quedo migrado a Flutter y separado en capas dentro de features/auth.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFFD5E6F6),
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _InfoTile(
                  title: 'Correo',
                  value: user?.email ?? 'Sin correo',
                  icon: Icons.mail_outline_rounded,
                ),
                const SizedBox(height: 12),
                _InfoTile(
                  title: 'Rol',
                  value: user?.rol ?? 'Rol ${user?.idRol ?? '-'}',
                  icon: Icons.badge_outlined,
                ),
                const SizedBox(height: 12),
                _InfoTile(
                  title: 'Token',
                  value: _maskToken(session?.token),
                  icon: Icons.lock_outline_rounded,
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: controller.logout,
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Cerrar sesion'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _maskToken(String? token) {
    if (token == null || token.isEmpty) {
      return 'No disponible';
    }

    if (token.length <= 16) {
      return token;
    }

    return '${token.substring(0, 12)}...${token.substring(token.length - 4)}';
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFDCE6F2)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FC),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF0B5CAD)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF577089),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
