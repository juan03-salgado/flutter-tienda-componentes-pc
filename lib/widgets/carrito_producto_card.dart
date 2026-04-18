import 'package:flutter/material.dart';
import 'package:tienda_pc/models/carritoProducto.dart';

class CarritoProductoCard extends StatelessWidget{
  final CarritoProducto carritoProducto;
  final VoidCallback sumar;
  final VoidCallback restar;
  final VoidCallback eliminar;

  const CarritoProductoCard({
    super.key,
    required this.carritoProducto,
    required this.sumar,
    required this.restar,
    required this.eliminar
  });

  @override
  Widget build(BuildContext context) {
     return Card(
      child: ListTile(
        leading: const Icon(Icons.shopping_bag_rounded),
        title: Text(carritoProducto.producto.nombre),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text("Cantidad: ${carritoProducto.cantidad}"),
          Text("Total: \$${carritoProducto.precioTotal}")
        ]
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: restar),
          IconButton(icon: const Icon(Icons.add_circle), onPressed: sumar),
          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: eliminar),
        ],
      ),
      )
     );
  }
}