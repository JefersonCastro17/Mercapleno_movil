// modulo_G

import 'package:flutter/material.dart';
import '../controllers/inventory_controller.dart';
import '../../domain/entities/product_movement.dart';

class MovementsPage extends StatelessWidget {
  const MovementsPage({super.key, required this.controller, this.productId, this.productName});

  final InventoryController controller;
  final String? productId;
  final String? productName;

  @override
  Widget build(BuildContext context) {
    final title = productName != null ? 'Historial - $productName' : 'Historial de movimientos';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: StreamBuilder<List<ProductMovement>>(
        stream: controller.movementsStream,
        initialData: controller.movements,
        builder: (context, snapshot) {
          final list = snapshot.data ?? [];
          final filtered = productId == null ? list : list.where((m) => m.productId == productId).toList();
          if (filtered.isEmpty) {
            return const Center(child: Text('No hay movimientos.'));
          }

          filtered.sort((a, b) => b.occurredAt.compareTo(a.occurredAt));

          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final m = filtered[index];
              final date = m.occurredAt.toLocal().toString().split('.').first;
              final qtyText = '${m.type == 'in' ? '+' : '-'}${m.quantity}';
              return ListTile(
                title: Text(qtyText, style: TextStyle(fontWeight: FontWeight.w600, color: m.type == 'in' ? Colors.green : Colors.red)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(date),
                    if (m.note != null && m.note!.isNotEmpty) Text(m.note!),
                  ],
                ),
                trailing: Text(m.productId),
              );
            },
          );
        },
      ),
    );
  }
}
