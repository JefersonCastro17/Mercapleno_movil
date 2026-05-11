import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/venta_totals.dart';
import '../../data/models/producto_model.dart';

class TicketScreen extends StatelessWidget {
  final Map<String, dynamic> ventaResult;
  final List<ProductoModel> productosComprados;
  final VentaTotals totales;

  const TicketScreen({
    super.key,
    required this.ventaResult,
    required this.productosComprados,
    required this.totales,
  });

  @override
  Widget build(BuildContext context) {
    // Formato de moneda localizado para Colombia (igual que la Web)
    final currencyFormat = NumberFormat.currency(
      locale: 'es_CO', 
      symbol: '\$', 
      decimalDigits: 0
    );
    
    // Fecha actual para el comprobante
    final fechaStr = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Comprobante de Venta'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Card que simula el papel del ticket
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  children: [
                    // Encabezado de Éxito
                    const Icon(Icons.check_circle, color: Colors.green, size: 70),
                    const SizedBox(height: 10),
                    const Text(
                      '¡VENTA EXITOSA!',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Ticket #: ${ventaResult['id'] ?? ventaResult['ticketId'] ?? 'N/A'}',
                      style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w600),
                    ),
                    const Divider(height: 40, thickness: 1.5),

                    // Información de Comercio y Cliente (Igual a la Web)
                    _buildHeaderInfo('MERCAPLENO', fechaStr),
                    const SizedBox(height: 10),
                    _buildHeaderInfo(
                      'CLIENTE:', 
                      ventaResult['cliente'] ?? 'Consumidor Final',
                      isBold: false
                    ),
                    const SizedBox(height: 30),

                    // Título de la tabla de productos
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'DETALLE DE PRODUCTOS',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    // Listado de productos (Réplica de la tabla Web)
                    ...productosComprados.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                            child: Text('${item.cantidad}x', style: const TextStyle(fontWeight: FontWeight.w500)),
                          ),
                          Expanded(
                            child: Text(
                              item.nombre,
                              style: const TextStyle(fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            currencyFormat.format(item.subtotal),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )),

                    const Divider(height: 40, thickness: 1.5),

                    // Bloque de Totales (Réplica de TotalsSummary.jsx)
                    _buildTotalRow('Subtotal:', currencyFormat.format(totales.subTotal)),
                    _buildTotalRow('Impuestos (19% IVA):', currencyFormat.format(totales.tax)),
                    const SizedBox(height: 10),
                    _buildTotalRow(
                      'TOTAL FINAL:', 
                      currencyFormat.format(totales.finalTotal), 
                      isBold: true,
                      large: true
                    ),
                    
                    const SizedBox(height: 40),
                    const Text(
                      'Gracias por su compra en Mercapleno',
                      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                    ),
                    const Text(
                      'Este es un comprobante electrónico válido.',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Botón de salida
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                ),
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text(
                  'VOLVER AL INICIO',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para filas de encabezado (Empresa, Cliente, Fecha)
  Widget _buildHeaderInfo(String left, String right, {bool isBold = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(left, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 13)),
        Text(right, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  // Widget auxiliar para las filas de totales
  Widget _buildTotalRow(String label, String value, {bool isBold = false, bool large = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label, 
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal, 
              fontSize: large ? 18 : 14
            )
          ),
          Text(
            value, 
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal, 
              fontSize: large ? 20 : 14,
              color: large ? Colors.blue[900] : Colors.black
            )
          ),
        ],
      ),
    );
  }
}