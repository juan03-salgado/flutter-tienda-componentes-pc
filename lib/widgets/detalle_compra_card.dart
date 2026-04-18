import 'package:flutter/material.dart';
import 'package:tienda_pc/models/detalleCompra.dart';

class DetalleCompraCard extends StatelessWidget{
  final Detallecompra detalle;

  const DetalleCompraCard({
    super.key,
    required this.detalle
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: const Icon(Icons.inventory_2),
        title: Text(detalle.producto),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Categoria ${detalle.categoria}"),
            Text("Cantidad ${detalle.cantidad}"),
            Text("Subtotal: \$${detalle.precioTotal.toStringAsFixed(2)}")
          ],
        ),
      ),
    );
  }

}