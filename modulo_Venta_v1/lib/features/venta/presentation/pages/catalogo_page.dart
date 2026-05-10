import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/venta_provider.dart';
import '../widgets/filter_bottom_sheet.dart';

class CatalogoPage extends StatefulWidget {
  const CatalogoPage({super.key});

  @override
  State<CatalogoPage> createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
  @override
  void initState() {
    super.initState();
    // Cargar productos al iniciar, similar a useEffect en Vite
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VentaProvider>().loadCatalogo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ventaProvider = context.watch<VentaProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MercaPleno', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          // Botón de Filtro (Igual que en el video de la web)
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => FilterBottomSheet(),
            ),
          ),
          // Carrito con Badge
          _CartBadge(count: ventaProvider.cart.length),
        ],
      ),
      body: ventaProvider.isLoading 
        ? const Center(child: CircularProgressIndicator())
        : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: ventaProvider.productos.length,
            itemBuilder: (context, index) {
              final producto = ventaProvider.productos[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        producto.urlImagenCompleta, // Usando la lógica de imageUtils
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(producto.nombre, maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text('\$${producto.precio.toStringAsFixed(0)}', 
                            style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => ventaProvider.addToCart(producto),
                              child: const Icon(Icons.add_shopping_cart, size: 18),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
    );
  }
}

class _CartBadge extends StatelessWidget {
  final int count;
  const _CartBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () => Navigator.pushNamed(context, '/carrito'),
        ),
        if (count > 0)
          Positioned(
            right: 8, top: 8,
            child: CircleAvatar(
              radius: 8, backgroundColor: Colors.red,
              child: Text('$count', style: const TextStyle(fontSize: 10, color: Colors.white)),
            ),
          )
      ],
    );
  }
}