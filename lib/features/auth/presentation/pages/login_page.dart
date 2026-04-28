import 'package:flutter/material.dart';
import 'package:mercapleno_appv1/core/config/app_config.dart';
import 'package:mercapleno_appv1/features/auth/presentation/controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.controller});

  final AuthController controller;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _credentialsFormKey = GlobalKey<FormState>();
  final _twoFactorFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = widget.controller;
    final isTwoFactorStep = controller.currentStep == AuthStep.twoFactor;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A4D92), Color(0xFF0D2E4D), Color(0xFFF4F7FB)],
            stops: [0, 0.35, 1],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 48,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const _BrandHeader(),
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              isTwoFactorStep
                                  ? 'Verificacion de seguridad'
                                  : 'Iniciar sesion',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isTwoFactorStep
                                  ? 'Completa el segundo factor para terminar tu acceso.'
                                  : 'Migracion del login web a Flutter, separada por capas dentro de features.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF52606D),
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (controller.errorMessage != null)
                              _MessageCard(
                                message: controller.errorMessage!,
                                backgroundColor: const Color(0xFFFFE6E3),
                                foregroundColor: const Color(0xFF8F3020),
                                icon: Icons.error_outline,
                              ),
                            if (controller.infoMessage != null)
                              Padding(
                                padding: EdgeInsets.only(
                                  top: controller.errorMessage == null ? 0 : 12,
                                ),
                                child: _MessageCard(
                                  message: controller.infoMessage!,
                                  backgroundColor: const Color(0xFFE7F2FF),
                                  foregroundColor: const Color(0xFF0B4A8B),
                                  icon: Icons.info_outline,
                                ),
                              ),
                            const SizedBox(height: 20),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 220),
                              child: isTwoFactorStep
                                  ? _buildTwoFactorForm(controller)
                                  : _buildCredentialsForm(controller),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7FAFD),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(0xFFE0E8F0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'API actual',
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: const Color(0xFF0B4A8B),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    AppConfig.apiBaseUrl,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Si vas a probar en un dispositivo fisico, ejecuta el app con --dart-define=API_BASE_URL=http://TU_IP:4000',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF64748B),
                                      height: 1.45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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

  Widget _buildCredentialsForm(AuthController controller) {
    return Form(
      key: _credentialsFormKey,
      child: Column(
        key: const ValueKey('credentials_form'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Correo electronico',
              hintText: 'correo@mercapleno.com',
              prefixIcon: Icon(Icons.alternate_email_rounded),
            ),
            validator: (value) {
              final email = value?.trim() ?? '';
              if (email.isEmpty) {
                return 'Ingresa tu correo.';
              }

              final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
              if (!emailRegex.hasMatch(email)) {
                return 'Ingresa un correo valido.';
              }

              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Contrasena',
              hintText: 'Ingresa tu contrasena',
              prefixIcon: Icon(Icons.lock_outline_rounded),
            ),
            onFieldSubmitted: (_) => _submitCredentials(controller),
            validator: (value) {
              if ((value ?? '').isEmpty) {
                return 'Ingresa tu contrasena.';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: controller.isSubmitting
                ? null
                : () => _submitCredentials(controller),
            child: controller.isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white,
                    ),
                  )
                : const Text('Ingresar'),
          ),
        ],
      ),
    );
  }

  Widget _buildTwoFactorForm(AuthController controller) {
    final challenge = controller.challenge;

    return Form(
      key: _twoFactorFormKey,
      child: Column(
        key: const ValueKey('two_factor_form'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF7E8),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFF7D287)),
            ),
            child: Text(
              'Ingresa el codigo enviado a ${challenge?.email ?? _emailController.text.trim()}'
              '${challenge?.expiresInMinutes != null ? ' . Vence en ${challenge!.expiresInMinutes} minutos.' : ''}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF805400),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _codeController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Codigo de seguridad',
              hintText: 'Ejemplo: 123456',
              prefixIcon: Icon(Icons.password_rounded),
            ),
            onFieldSubmitted: (_) => _submitTwoFactorCode(controller),
            validator: (value) {
              final code = value?.trim() ?? '';
              if (code.isEmpty) {
                return 'Ingresa el codigo recibido.';
              }

              if (code.length < 6) {
                return 'El codigo debe tener al menos 6 digitos.';
              }

              return null;
            },
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: controller.isSubmitting
                ? null
                : () => _submitTwoFactorCode(controller),
            child: controller.isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white,
                    ),
                  )
                : const Text('Verificar codigo'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: controller.isSubmitting
                ? null
                : () {
                    _codeController.clear();
                    controller.cancelTwoFactorFlow();
                  },
            child: const Text('Volver al login'),
          ),
        ],
      ),
    );
  }

  void _submitCredentials(AuthController controller) {
    FocusScope.of(context).unfocus();
    if (!(_credentialsFormKey.currentState?.validate() ?? false)) {
      return;
    }

    controller.loginWithCredentials(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  void _submitTwoFactorCode(AuthController controller) {
    FocusScope.of(context).unfocus();
    if (!(_twoFactorFormKey.currentState?.validate() ?? false)) {
      return;
    }

    controller.verifyTwoFactorCode(_codeController.text.trim());
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF4A300), Color(0xFFF97316)],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3DF4A300),
                blurRadius: 24,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'M',
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Mercapleno Mobile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Autenticacion migrada desde el portal web',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFD5E6F6),
            fontSize: 15,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({
    required this.message,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
  });

  final String message;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: foregroundColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: foregroundColor,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
