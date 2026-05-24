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
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: (carritoProducto.producto?.imagenUrl != null && carritoProducto.producto!.imagenUrl!.isNotEmpty)
          ? Image.network(
            carritoProducto.producto!.imagenUrl!,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.image_not_supported, color: Colors.grey);
            }
          ) 
          : const Icon(Icons.shopping_bag, color: Colors.orange),
        ),
        title: Text(carritoProducto.producto?.nombre ?? 'Producto', maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Cantidad: ${carritoProducto.cantidad}"),
            Text("Total: \$${(carritoProducto.precioTotal ?? 0).toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green))
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: restar, icon: Icon(Icons.remove_circle_outline)),
            IconButton(onPressed: sumar, icon: Icon(Icons.add_circle)),
            IconButton(onPressed: eliminar, icon: Icon(Icons.delete, color: Colors.red)),
          ],
        ),
      ),
     );
  }
}  
