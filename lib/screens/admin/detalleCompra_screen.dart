import 'package:flutter/material.dart';
import 'package:tienda_pc/models/compras.dart';
import 'package:tienda_pc/widgets/detalle_compra_card.dart';

class DetallecompraScreen extends StatelessWidget {
  final Compras compra;

  const DetallecompraScreen({
    super.key,
    required this.compra
  });

  Color _colorEstado(String estado){
    switch(estado){
      case "PENDIENTE":
      return Colors.orange;
      case "COMPLETADA": 
      return Colors.green;
      case "CANCELADA":
      return Colors.red;
      default:
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = compra.productos.fold(0.0, (sum, item) => sum + item.precioTotal);
    return Scaffold(
      appBar: AppBar(
        title: Text("Compra #${compra.idCompra}")
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Cliente: ${compra.cliente}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),

                  Text("Referencia ${compra.referenciaPago}"),
                  Text("Fecha: ${compra.fechaCompra}"),
                  SizedBox(height: 5),

                  Row(
                    children: [
                      const Text("Estado: "),
                      Text(compra.estado, style: TextStyle(color: _colorEstado(compra.estado), fontWeight: FontWeight.bold))
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: compra.productos.isEmpty ? const Center(child: Text("No hay productos")) : ListView.builder(
              itemCount: compra.productos.length,
              itemBuilder: (context, index) {
                final detalle = compra.productos[index];
                return DetalleCompraCard(detalle: detalle);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            color: Colors.grey[200],
            child: Text("Total: \$${total.toStringAsFixed(2)}", textAlign: TextAlign.end, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}