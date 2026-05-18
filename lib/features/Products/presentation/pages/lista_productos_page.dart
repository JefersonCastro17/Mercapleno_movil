import 'package:flutter/material.dart';
import '../../domain/entities/product_entity.dart';
import '../controllers/product_controller.dart';
import '../widgets/product_form_modal.dart';

class ListaProductosPage extends StatefulWidget {
  final ProductController controller;
  const ListaProductosPage({super.key, required this.controller});

  @override
  State<ListaProductosPage> createState() => _ListaProductosPageState();
}

class _ListaProductosPageState extends State<ListaProductosPage> {
  final String _token = "TU_TOKEN_AQUI";
  String _searchTerm = "";
  String _statusFilter = "todos";

  @override
  void initState() {
    super.initState();
    widget.controller.loadProducts(_token);
    widget.controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerUpdate);
    super.dispose();
  }

  List<ProductEntity> get _filteredProducts {
    return widget.controller.products.where((p) {
      final matchesSearch =
          _searchTerm.isEmpty ||
          p.nombre.toLowerCase().contains(_searchTerm.toLowerCase()) ||
          p.id.toString().contains(_searchTerm);
      final matchesStatus =
          _statusFilter == "todos" ||
          p.estado.toLowerCase() == _statusFilter.toLowerCase();
      return matchesSearch && matchesStatus;
    }).toList();
  }

  void _openForm({ProductEntity? producto}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ProductFormModal(
        producto: producto,
        onSave: (fields, file) async {
          await widget.controller.saveProduct(
            token: _token,
            id: producto?.id,
            fields: fields,
            imageFile: file,
          );
          if (mounted) Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.controller;

    return Scaffold(
      appBar: AppBar(title: const Text('Inventario Mercapleno')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Buscar por nombre o ID...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (v) => setState(() => _searchTerm = v),
                  ),
                ),
                DropdownButton<String>(
                  value: _statusFilter,
                  items: const [
                    DropdownMenuItem(value: "todos", child: Text("Todos")),
                    DropdownMenuItem(
                      value: "Disponible",
                      child: Text("Disponibles"),
                    ),
                    DropdownMenuItem(value: "Agotado", child: Text("Agotados")),
                  ],
                  onChanged: (v) => setState(() => _statusFilter = v!),
                ),
              ],
            ),
          ),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, idx) {
                      final p = _filteredProducts[idx];
                      return ListTile(
                        leading: p.imagen.isNotEmpty
                            ? Image.network(
                                p.imagen,
                                width: 50,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image),
                              )
                            : const Icon(Icons.shopping_basket),
                        title: Text(p.nombre),
                        subtitle: Text('\$${p.precio} - ${p.estado}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _openForm(producto: p),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  state.deleteProduct(p.id, _token),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
