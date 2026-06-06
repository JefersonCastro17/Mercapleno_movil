// modulo_G

import 'package:flutter/material.dart';
import '../controllers/inventory_controller.dart';
import 'movements_page.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key, required this.controller});

  final InventoryController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventario'), actions: [
        IconButton(
          tooltip: 'Ver historial',
          icon: const Icon(Icons.history),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => MovementsPage(controller: controller)));
          },
        )
      ]),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.error != null) {
            return Center(child: Text('Error: ${controller.error}'));
          }

          final products = controller.products;
          final stock = controller.currentStock;

          if (products.isEmpty) {
            return const Center(child: Text('No hay productos.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: products.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final p = products[index];
              final q = stock[p.id] ?? 0;
              return ListTile(
                title: Text(p.name),
                subtitle: Text(p.sku ?? ''),
                trailing: Text(q.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                onTap: () async {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => MovementsPage(controller: controller, productId: p.id, productName: p.name)));
                },
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'in',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => _MovementFormWrapper(controller: controller, type: 'in')));
            },
            label: const Text('Entrada'),
            icon: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.extended(
            heroTag: 'out',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => _MovementFormWrapper(controller: controller, type: 'out')));
            },
            label: const Text('Salida'),
            icon: const Icon(Icons.remove),
            backgroundColor: Colors.redAccent,
          ),
        ],
      ),
    );
  }
}

class _MovementFormWrapper extends StatelessWidget {
  const _MovementFormWrapper({required this.controller, required this.type});

  final InventoryController controller;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(type == 'in' ? 'Registrar Entrada' : 'Registrar Salida')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _MovementForm(controller: controller, type: type),
      ),
    );
  }
}

class _MovementForm extends StatefulWidget {
  const _MovementForm({required this.controller, required this.type});

  final InventoryController controller;
  final String type;

  @override
  State<_MovementForm> createState() => _MovementFormState();
}

class _MovementFormState extends State<_MovementForm> {
  String? _selectedProductId;
  final _qtyCtl = TextEditingController();
  final _noteCtl = TextEditingController();

  @override
  void dispose() {
    _qtyCtl.dispose();
    _noteCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = widget.controller.products;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          initialValue: _selectedProductId,
          items: products.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
          onChanged: (v) => setState(() => _selectedProductId = v),
          decoration: const InputDecoration(labelText: 'Producto'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _qtyCtl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Cantidad'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _noteCtl,
          decoration: const InputDecoration(labelText: 'Nota (opcional)'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            final pid = _selectedProductId;
            final q = int.tryParse(_qtyCtl.text);
            if (pid == null || q == null || q <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona producto y cantidad valida')));
              return;
            }

            await widget.controller.createMovement(productId: pid, quantity: q, type: widget.type, note: _noteCtl.text.isEmpty ? null : _noteCtl.text);
            Navigator.of(context).pop();
          },
          child: Text(widget.type == 'in' ? 'Registrar Entrada' : 'Registrar Salida'),
        ),
      ],
    );
  }
}
