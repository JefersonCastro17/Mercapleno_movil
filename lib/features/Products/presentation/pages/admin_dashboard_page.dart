import 'package:flutter/material.dart';
import 'lista_productos_page.dart';
import '../controllers/product_controller.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Panel de Administración")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ListaProductosPage(controller: ProductController()),
              ),
            );
          },
          child: const Text("Gestionar Productos"),
        ),
      ),
    );
  }
}
