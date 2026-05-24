import 'package:flutter/material.dart';
import 'package:tienda_pc/features/productos/screens/detalle_productos_screen.dart';
import 'package:tienda_pc/models/productos.dart';
import 'package:tienda_pc/models/usuarios.dart';

class ProductoRelacionadoCard extends StatelessWidget {
  final Producto producto;
  final Usuario usuario;

  const ProductoRelacionadoCard({
    super.key, 
    required this.producto,
    required this.usuario
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetalleProductosScreen(producto: producto, usuario: usuario)));
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 2)
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: SizedBox(
                  width: double.infinity,
                  child: producto.imagenUrl != null ? Image.network(producto.imagenUrl!, fit: BoxFit.cover) 
                  : Container(color: Colors.grey.shade200, child: const Icon(Icons.image, size: 60, color: Colors.grey))
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(producto.nombre, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.2)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.store, size: 14, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(producto.nombreTienda!, style: const TextStyle(fontSize: 12, color: Colors.grey))
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text("\$${producto.precioUnidad.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 61, 144, 177)))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}