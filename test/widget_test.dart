import 'package:flutter_test/flutter_test.dart';
import 'package:mercapleno_appv1/app/app.dart';
import 'package:mercapleno_appv1/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('renderiza la pantalla de login al iniciar sin sesion', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final authController = await createAuthController();

    await tester.pumpWidget(MyApp(authController: authController));
    await tester.pumpAndSettle();

    expect(find.text('Iniciar sesion'), findsOneWidget);
    expect(find.text('Correo electronico'), findsOneWidget);
    expect(find.text('Contrasena'), findsOneWidget);
  });
}
