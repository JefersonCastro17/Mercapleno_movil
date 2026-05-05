import 'package:flutter/material.dart';
import 'package:mercapleno_appv1/features/auth/domain/entities/register_request.dart';
import 'package:mercapleno_appv1/features/auth/presentation/controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.controller});

  final AuthController controller;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final _twoFactorFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  final _verifyEmailFormKey = GlobalKey<FormState>();
  final _requestResetFormKey = GlobalKey<FormState>();
  final _resetPasswordFormKey = GlobalKey<FormState>();

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _twoFactorCodeController = TextEditingController();

  final _registerNombreController = TextEditingController();
  final _registerApellidoController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _registerDireccionController = TextEditingController();
  final _registerNumeroIdentificacionController = TextEditingController();
  final _registerBirthDateController = TextEditingController();

  final _verifyEmailController = TextEditingController();
  final _verifyCodeController = TextEditingController();

  final _requestResetEmailController = TextEditingController();

  final _resetEmailController = TextEditingController();
  final _resetCodeController = TextEditingController();
  final _resetPasswordController = TextEditingController();
  final _resetConfirmPasswordController = TextEditingController();

  int? _selectedDocumentTypeId;
  DateTime? _selectedBirthDate;
  AuthView? _lastView;
  String? _lastSyncedEmail;

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _twoFactorCodeController.dispose();
    _registerNombreController.dispose();
    _registerApellidoController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerDireccionController.dispose();
    _registerNumeroIdentificacionController.dispose();
    _registerBirthDateController.dispose();
    _verifyEmailController.dispose();
    _verifyCodeController.dispose();
    _requestResetEmailController.dispose();
    _resetEmailController.dispose();
    _resetCodeController.dispose();
    _resetPasswordController.dispose();
    _resetConfirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final controller = widget.controller;
        _syncControllerState(controller);
        _handleAuthenticatedState(controller);

        final theme = Theme.of(context);
        final view = controller.currentView;

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0A4D92),
                    Color(0xFF0D2E4D),
                    Color(0xFFF4F7FB),
                  ],
                  stops: [0, 0.35, 1],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
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
                                    _titleFor(view),
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _subtitleFor(view),
                                    style: theme.textTheme.bodyMedium
                                        ?.copyWith(
                                          color: const Color(0xFF52606D),
                                          height: 1.5,
                                        ),
                                  ),
                                  if (view == AuthView.register &&
                                      controller.isLoadingDocumentTypes) ...[
                                    const SizedBox(height: 16),
                                    const LinearProgressIndicator(
                                      minHeight: 5,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(99),
                                      ),
                                    ),
                                  ],
                                  if (controller.errorMessage != null) ...[
                                    const SizedBox(height: 20),
                                    _MessageCard(
                                      message: controller.errorMessage!,
                                      backgroundColor: const Color(
                                        0xFFFFE6E3,
                                      ),
                                      foregroundColor: const Color(
                                        0xFF8F3020,
                                      ),
                                      icon: Icons.error_outline,
                                    ),
                                  ],
                                  if (controller.infoMessage != null) ...[
                                    const SizedBox(height: 12),
                                    _MessageCard(
                                      message: controller.infoMessage!,
                                      backgroundColor: const Color(
                                        0xFFE7F2FF,
                                      ),
                                      foregroundColor: const Color(
                                        0xFF0B4A8B,
                                      ),
                                      icon: Icons.info_outline,
                                    ),
                                  ],
                                  const SizedBox(height: 20),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 220),
                                    child: _buildCurrentForm(controller),
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
            bottomNavigationBar: _buildBottomMenu(view, controller),
          ),
        );
      },
    );
  }

  void _handleAuthenticatedState(AuthController controller) {
    if (!controller.isAuthenticated || !mounted) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final navigator = Navigator.of(context);
      if (navigator.canPop()) {
        navigator.popUntil((route) => route.isFirst);
      }
    });
  }

  Widget _buildBottomMenu(AuthView view, AuthController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: const Icon(Icons.home),
              label: const Text('Inicio'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.icon(
              onPressed: () {
                if (view == AuthView.register) {
                  controller.showLogin(email: _registerEmailController.text.trim());
                } else {
                  controller.showRegister();
                }
              },
              icon: Icon(view == AuthView.register ? Icons.login : Icons.person_add),
              label: Text(view == AuthView.register ? 'Iniciar sesión' : 'Registrarme'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentForm(AuthController controller) {
    switch (controller.currentView) {
      case AuthView.login:
        return _buildLoginForm(controller);
      case AuthView.twoFactor:
        return _buildTwoFactorForm(controller);
      case AuthView.register:
        return _buildRegisterForm(controller);
      case AuthView.verifyEmail:
        return _buildVerifyEmailForm(controller);
      case AuthView.requestPasswordReset:
        return _buildRequestResetForm(controller);
      case AuthView.resetPassword:
        return _buildResetPasswordForm(controller);
    }
  }

  Widget _buildLoginForm(AuthController controller) {
    return Form(
      key: _loginFormKey,
      child: Column(
        key: const ValueKey('login_form'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _loginEmailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Correo electronico',
              hintText: 'correo@mercapleno.com',
              prefixIcon: Icon(Icons.alternate_email_rounded),
            ),
            validator: _validateEmail,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _loginPasswordController,
            obscureText: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Contrasena',
              hintText: 'Ingresa tu contrasena',
              prefixIcon: Icon(Icons.lock_outline_rounded),
            ),
            validator: (value) => _validateRequired(value, 'Ingresa tu contrasena.'),
            onFieldSubmitted: (_) => _submitLogin(controller),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: controller.isSubmitting
                ? null
                : () => _submitLogin(controller),
            child: _buildButtonChild(
              isLoading: controller.isSubmitting,
              label: 'Ingresar',
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: controller.isSubmitting
                ? null
                : () {
                    controller.showRegister();
                  },
            child: const Text('Crear cuenta'),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              TextButton(
                onPressed: controller.isSubmitting
                    ? null
                    : () => controller.showVerifyEmail(
                          email: _loginEmailController.text.trim(),
                        ),
                child: const Text('Verificar correo'),
              ),
              TextButton(
                onPressed: controller.isSubmitting
                    ? null
                    : () => controller.showForgotPassword(
                          email: _loginEmailController.text.trim(),
                        ),
                child: const Text('Olvide mi contrasena'),
              ),
            ],
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
              'Ingresa el codigo enviado a ${challenge?.email ?? _loginEmailController.text.trim()}'
              '${challenge?.expiresInMinutes != null ? '. Vence en ${challenge!.expiresInMinutes} minutos.' : ''}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF805400),
                    height: 1.5,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _twoFactorCodeController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Codigo de seguridad',
              hintText: 'Ejemplo: 123456',
              prefixIcon: Icon(Icons.password_rounded),
            ),
            validator: _validateCode,
            onFieldSubmitted: (_) => _submitTwoFactor(controller),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: controller.isSubmitting
                ? null
                : () => _submitTwoFactor(controller),
            child: _buildButtonChild(
              isLoading: controller.isSubmitting,
              label: 'Verificar codigo',
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: controller.isSubmitting
                ? null
                : controller.cancelTwoFactorFlow,
            child: const Text('Volver al login'),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm(AuthController controller) {
    return Form(
      key: _registerFormKey,
      child: Column(
        key: const ValueKey('register_form'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _registerNombreController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Nombre',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
            validator: (value) => _validateRequired(value, 'Ingresa tu nombre.'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _registerApellidoController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Apellido',
              prefixIcon: Icon(Icons.badge_outlined),
            ),
            validator: (value) =>
                _validateRequired(value, 'Ingresa tu apellido.'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            initialValue: _selectedDocumentTypeId,
            items: controller.documentTypes
                .map(
                  (documentType) => DropdownMenuItem<int>(
                    value: documentType.id,
                    child: Text(documentType.nombre),
                  ),
                )
                .toList(growable: false),
            onChanged: controller.isSubmitting || controller.isLoadingDocumentTypes
                ? null
                : (value) {
                    setState(() {
                      _selectedDocumentTypeId = value;
                    });
                  },
            decoration: const InputDecoration(
              labelText: 'Tipo de identificacion',
              prefixIcon: Icon(Icons.credit_card_rounded),
            ),
            validator: (value) {
              if (value == null) {
                return 'Selecciona un tipo de identificacion.';
              }
              return null;
            },
          ),
          if (controller.documentTypesError != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    controller.documentTypesError!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFFB42318),
                        ),
                  ),
                ),
                TextButton(
                  onPressed: controller.isLoadingDocumentTypes
                      ? null
                      : () {
                          controller.loadDocumentTypes(force: true);
                        },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          TextFormField(
            controller: _registerNumeroIdentificacionController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Numero de identificacion',
              prefixIcon: Icon(Icons.numbers_rounded),
            ),
            validator: (value) => _validateRequired(
              value,
              'Ingresa tu numero de identificacion.',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _registerBirthDateController,
            readOnly: true,
            onTap: _pickBirthDate,
            decoration: const InputDecoration(
              labelText: 'Fecha de nacimiento',
              prefixIcon: Icon(Icons.calendar_month_rounded),
            ),
            validator: (value) =>
                _validateRequired(value, 'Selecciona tu fecha de nacimiento.'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _registerEmailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Correo electronico',
              prefixIcon: Icon(Icons.mail_outline_rounded),
            ),
            validator: _validateEmail,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _registerDireccionController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Direccion',
              prefixIcon: Icon(Icons.home_work_outlined),
            ),
            validator: (value) =>
                _validateRequired(value, 'Ingresa tu direccion.'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _registerPasswordController,
            obscureText: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Contrasena',
              prefixIcon: Icon(Icons.lock_person_outlined),
            ),
            validator: _validatePassword,
            onFieldSubmitted: (_) => _submitRegister(controller),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: controller.isSubmitting || controller.isLoadingDocumentTypes
                ? null
                : () => _submitRegister(controller),
            child: _buildButtonChild(
              isLoading: controller.isSubmitting,
              label: 'Crear cuenta',
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: controller.isSubmitting
                ? null
                : () => controller.showLogin(
                      email: _registerEmailController.text.trim(),
                    ),
            child: const Text('Ya tengo cuenta'),
          ),
          TextButton(
            onPressed: controller.isSubmitting
                ? null
                : () => controller.showVerifyEmail(
                      email: _registerEmailController.text.trim(),
                    ),
            child: const Text('Ya tengo codigo de verificacion'),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyEmailForm(AuthController controller) {
    return Form(
      key: _verifyEmailFormKey,
      child: Column(
        key: const ValueKey('verify_email_form'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _verifyEmailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Correo electronico',
              prefixIcon: Icon(Icons.mail_outline_rounded),
            ),
            validator: _validateEmail,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _verifyCodeController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Codigo',
              hintText: '6 digitos',
              prefixIcon: Icon(Icons.verified_outlined),
            ),
            validator: _validateCode,
            onFieldSubmitted: (_) => _submitVerifyEmail(controller),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: controller.isSubmitting
                ? null
                : () => _submitVerifyEmail(controller),
            child: _buildButtonChild(
              isLoading: controller.isSubmitting,
              label: 'Verificar correo',
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: controller.isSubmitting
                ? null
                : () {
                    controller.resendVerification(
                      email: _verifyEmailController.text.trim(),
                    );
                  },
            child: const Text('Reenviar codigo'),
          ),
          TextButton(
            onPressed: controller.isSubmitting
                ? null
                : () => controller.showLogin(
                      email: _verifyEmailController.text.trim(),
                    ),
            child: const Text('Volver al login'),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestResetForm(AuthController controller) {
    return Form(
      key: _requestResetFormKey,
      child: Column(
        key: const ValueKey('request_reset_form'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _requestResetEmailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Correo electronico',
              prefixIcon: Icon(Icons.alternate_email_rounded),
            ),
            validator: _validateEmail,
            onFieldSubmitted: (_) => _submitRequestReset(controller),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: controller.isSubmitting
                ? null
                : () => _submitRequestReset(controller),
            child: _buildButtonChild(
              isLoading: controller.isSubmitting,
              label: 'Enviar codigo',
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: controller.isSubmitting
                ? null
                : () => controller.showLogin(
                      email: _requestResetEmailController.text.trim(),
                    ),
            child: const Text('Volver al login'),
          ),
        ],
      ),
    );
  }

  Widget _buildResetPasswordForm(AuthController controller) {
    return Form(
      key: _resetPasswordFormKey,
      child: Column(
        key: const ValueKey('reset_password_form'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _resetEmailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Correo electronico',
              prefixIcon: Icon(Icons.mail_outline_rounded),
            ),
            validator: _validateEmail,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _resetCodeController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Codigo',
              hintText: '6 digitos',
              prefixIcon: Icon(Icons.password_rounded),
            ),
            validator: _validateCode,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _resetPasswordController,
            obscureText: true,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Nueva contrasena',
              prefixIcon: Icon(Icons.lock_reset_outlined),
            ),
            validator: _validatePassword,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _resetConfirmPasswordController,
            obscureText: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Confirmar contrasena',
              prefixIcon: Icon(Icons.lock_outline_rounded),
            ),
            validator: (value) {
              final requiredMessage =
                  _validateRequired(value, 'Confirma tu nueva contrasena.');
              if (requiredMessage != null) {
                return requiredMessage;
              }

              if (value != _resetPasswordController.text) {
                return 'Las contrasenas no coinciden.';
              }

              return null;
            },
            onFieldSubmitted: (_) => _submitResetPassword(controller),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: controller.isSubmitting
                ? null
                : () => _submitResetPassword(controller),
            child: _buildButtonChild(
              isLoading: controller.isSubmitting,
              label: 'Actualizar contrasena',
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: controller.isSubmitting
                ? null
                : () => controller.showForgotPassword(
                      email: _resetEmailController.text.trim(),
                    ),
            child: const Text('Solicitar un nuevo codigo'),
          ),
          TextButton(
            onPressed: controller.isSubmitting
                ? null
                : () => controller.showLogin(
                      email: _resetEmailController.text.trim(),
                    ),
            child: const Text('Volver al login'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final initialDate =
        _selectedBirthDate ?? DateTime(now.year - 18, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (!mounted || pickedDate == null) {
      return;
    }

    setState(() {
      _selectedBirthDate = pickedDate;
      _registerBirthDateController.text = _formatDate(pickedDate);
    });
  }

  void _submitLogin(AuthController controller) {
    if (controller.isSubmitting) {
      return;
    }

    FocusScope.of(context).unfocus();
    if (!(_loginFormKey.currentState?.validate() ?? false)) {
      return;
    }

    controller.loginWithCredentials(
      email: _loginEmailController.text.trim(),
      password: _loginPasswordController.text,
    );
  }

  void _submitTwoFactor(AuthController controller) {
    if (controller.isSubmitting) {
      return;
    }

    FocusScope.of(context).unfocus();
    if (!(_twoFactorFormKey.currentState?.validate() ?? false)) {
      return;
    }

    controller.verifyTwoFactorCode(_twoFactorCodeController.text.trim());
  }

  void _submitRegister(AuthController controller) {
    if (controller.isSubmitting) {
      return;
    }

    FocusScope.of(context).unfocus();
    if (!(_registerFormKey.currentState?.validate() ?? false)) {
      return;
    }

    final birthDate = _selectedBirthDate;
    if (birthDate == null) {
      return;
    }

    if (_calculateAge(birthDate) < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes tener al menos 10 anos para registrarte.'),
        ),
      );
      return;
    }

    final documentTypeId = _selectedDocumentTypeId;
    if (documentTypeId == null) {
      return;
    }

    controller.register(
      RegisterRequest(
        nombre: _registerNombreController.text.trim(),
        apellido: _registerApellidoController.text.trim(),
        email: _registerEmailController.text.trim(),
        password: _registerPasswordController.text,
        direccion: _registerDireccionController.text.trim(),
        fechaNacimiento: _registerBirthDateController.text,
        idTipoIdentificacion: documentTypeId,
        numeroIdentificacion:
            _registerNumeroIdentificacionController.text.trim(),
      ),
    );
  }

  void _submitVerifyEmail(AuthController controller) {
    if (controller.isSubmitting) {
      return;
    }

    FocusScope.of(context).unfocus();
    if (!(_verifyEmailFormKey.currentState?.validate() ?? false)) {
      return;
    }

    controller.verifyEmail(
      email: _verifyEmailController.text.trim(),
      code: _verifyCodeController.text.trim(),
    );
  }

  void _submitRequestReset(AuthController controller) {
    if (controller.isSubmitting) {
      return;
    }

    FocusScope.of(context).unfocus();
    if (!(_requestResetFormKey.currentState?.validate() ?? false)) {
      return;
    }

    controller.requestPasswordReset(
      email: _requestResetEmailController.text.trim(),
    );
  }

  void _submitResetPassword(AuthController controller) {
    if (controller.isSubmitting) {
      return;
    }

    FocusScope.of(context).unfocus();
    if (!(_resetPasswordFormKey.currentState?.validate() ?? false)) {
      return;
    }

    controller.resetPassword(
      email: _resetEmailController.text.trim(),
      code: _resetCodeController.text.trim(),
      newPassword: _resetPasswordController.text,
    );
  }

  void _syncControllerState(AuthController controller) {
    final suggestedEmail = controller.suggestedEmail;
    if (suggestedEmail != null &&
        suggestedEmail.isNotEmpty &&
        suggestedEmail != _lastSyncedEmail) {
      _syncEmailController(_loginEmailController, suggestedEmail);
      _syncEmailController(_verifyEmailController, suggestedEmail);
      _syncEmailController(_requestResetEmailController, suggestedEmail);
      _syncEmailController(_resetEmailController, suggestedEmail);
      _syncEmailController(_registerEmailController, suggestedEmail);
      _lastSyncedEmail = suggestedEmail;
    }

    if (_lastView == controller.currentView) {
      return;
    }

    if (controller.currentView == AuthView.twoFactor) {
      _twoFactorCodeController.clear();
    }

    if (controller.currentView == AuthView.verifyEmail) {
      _verifyCodeController.clear();
    }

    if (controller.currentView == AuthView.resetPassword) {
      _resetCodeController.clear();
      _resetPasswordController.clear();
      _resetConfirmPasswordController.clear();
    }

    if (controller.currentView == AuthView.requestPasswordReset &&
        suggestedEmail != null &&
        suggestedEmail.isNotEmpty) {
      _requestResetEmailController.text = suggestedEmail;
    }

    _lastView = controller.currentView;
  }

  void _syncEmailController(TextEditingController textController, String email) {
    final currentValue = textController.text.trim();
    if (currentValue.isEmpty || currentValue == (_lastSyncedEmail ?? '')) {
      textController.text = email;
    }
  }

  String _titleFor(AuthView view) {
    switch (view) {
      case AuthView.login:
        return 'Iniciar sesion';
      case AuthView.twoFactor:
        return 'Verificacion de seguridad';
      case AuthView.register:
        return 'Crear cuenta';
      case AuthView.verifyEmail:
        return 'Verificar correo';
      case AuthView.requestPasswordReset:
        return 'Recuperar contrasena';
      case AuthView.resetPassword:
        return 'Actualizar contrasena';
    }
  }

  String _subtitleFor(AuthView view) {
    switch (view) {
      case AuthView.login:
        return 'Accede desde Flutter usando el backend actual de Mercapleno.';
      case AuthView.twoFactor:
        return 'Completa el segundo factor para terminar tu acceso.';
      case AuthView.register:
        return 'Registra tu usuario, valida tu correo y deja listo tu acceso.';
      case AuthView.verifyEmail:
        return 'Ingresa el codigo enviado a tu correo para activar la cuenta.';
      case AuthView.requestPasswordReset:
        return 'Solicita un codigo para recuperar tu contrasena.';
      case AuthView.resetPassword:
        return 'Ingresa el codigo recibido y define tu nueva contrasena.';
    }
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Ingresa tu correo.';
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) {
      return 'Ingresa un correo valido.';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) {
      return 'Ingresa una contrasena.';
    }

    if (password.length < 6) {
      return 'La contrasena debe tener al menos 6 caracteres.';
    }

    return null;
  }

  String? _validateCode(String? value) {
    final code = value?.trim() ?? '';
    if (code.isEmpty) {
      return 'Ingresa el codigo recibido.';
    }

    if (code.length != 6) {
      return 'El codigo debe tener 6 digitos.';
    }

    return null;
  }

  String? _validateRequired(String? value, String message) {
    if ((value ?? '').trim().isEmpty) {
      return message;
    }
    return null;
  }

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    var age = today.year - birthDate.year;
    final hasNotHadBirthday =
        today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day);
    if (hasNotHadBirthday) {
      age -= 1;
    }
    return age;
  }

  String _formatDate(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }

  Widget _buildButtonChild({
    required bool isLoading,
    required String label,
  }) {
    if (!isLoading) {
      return Text(label);
    }

    return const SizedBox(
      width: 22,
      height: 22,
      child: CircularProgressIndicator(
        strokeWidth: 2.4,
        color: Colors.white,
      ),
    );
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
          'Autenticacion, registro y recuperacion conectados al backend',
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
