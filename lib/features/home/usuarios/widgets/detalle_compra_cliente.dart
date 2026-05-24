import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tienda_pc/features/compras/widgets/detalle_compra_card.dart';
import 'package:tienda_pc/models/compras.dart';
import 'package:tienda_pc/models/usuarios.dart';

class DetalleCompraCliente extends StatelessWidget {
  final Compras compra;
  final Usuario usuario;

  const DetalleCompraCliente({
    super.key,
    required this.compra,
    required this.usuario
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
        title: Text("Factura #${compra.idCompra}"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(12),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Detalle de compra", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),

                    const Divider(),

                    Text("Cliente: ${compra.cliente}", style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 6),

                    Text("Referencia ${compra.referenciaPago}"),
                    const SizedBox(height: 6),

                    Text("Fecha: ${compra.fechaFormateada}"),
                    const SizedBox(height: 10),
        
                    Row(
                      children: [
                        const Text("Estado: "),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: _colorEstado(compra.estado).withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                          child: Text(compra.estado, style: TextStyle(color: _colorEstado(compra.estado), fontWeight: FontWeight.bold)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            const Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Productos", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )
            ),

            const SizedBox(height: 5),

            compra.productos.isEmpty ? const Center(child: Text("No hay productos"))
            : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: compra.productos.length,
              itemBuilder: (context, index) {
                final detalle = compra.productos[index];
                return DetalleCompraCard(
                  detalle: detalle, 
                  usuario: usuario,
                  estadoCompra: compra.estado
                );
              },
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(18),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: const Border(top: BorderSide(color: Colors.black12))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text("TOTAL A PAGAR", style: TextStyle(fontSize: 12)),
                    Text("\$${total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green))
                  ],
                ),
              ),
            ]
          )
        ),
      );
  }
}