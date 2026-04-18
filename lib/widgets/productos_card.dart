import 'package:flutter/material.dart';
import 'package:tienda_pc/models/productos.dart';

class ProductosCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback? editar;
  final VoidCallback? eliminar;
  final VoidCallback? onTap;
  final int rol;

  const ProductosCard({
    super.key,
    required this.editar,
    required this.eliminar,
    required this.onTap,
    required this.producto,
    required this.rol
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: producto.imagenUrl != null ? Image.network(producto.imagenUrl!, fit: BoxFit.cover) : const Icon(Icons.image),
                ),
                const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(producto.nombre, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(producto.descripcion, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 5),
                    Text("Categoria: ${producto.categoriaNombre ?? 'Sin categoría'}"),
                    const SizedBox(height: 5),
                    Text("Precio: \$${producto.precioUnidad.toStringAsFixed(2)}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              if(rol == 1 || rol == 2)
              Column(
                children: [
                  IconButton(icon: Icon(Icons.edit), onPressed: editar, style: IconButton.styleFrom(foregroundColor: Colors.blue),),
                  IconButton(icon: Icon(Icons.delete), onPressed: eliminar, style: IconButton.styleFrom(foregroundColor: Colors.red),)
                ],
              )            
            ],
          ),
        ),
      ),
    );
  }
}