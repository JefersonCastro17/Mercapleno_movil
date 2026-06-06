// modulo_G

import 'package:flutter/material.dart';
import 'core/network/api_client.dart';
import 'data/datasources/products_remote_data_source.dart';
import 'data/repositories/products_repository_impl.dart';
import 'presentation/controllers/inventory_controller.dart';
import 'presentation/pages/inventory_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final repo = ProductsRepositoryImpl(remote: ProductsRemoteDataSource(apiClient: ApiClient()));
  final controller = InventoryController(repository: repo);
  await controller.loadAll();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Modulo Inventario (standalone)',
    home: InventoryPage(controller: controller),
  ));
}
