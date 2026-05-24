import 'package:flutter/material.dart';
import 'package:tienda_pc/features/productos/screens/detalle_productos_screen.dart';
import 'package:tienda_pc/models/carritoProducto.dart';
import 'package:tienda_pc/models/productos.dart';
import 'package:tienda_pc/models/usuarios.dart';
import 'package:tienda_pc/services/carritoProductos.service.dart';

class HomeClienteCard extends StatelessWidget {
  final Producto producto;
  final Usuario usuario;

    HomeClienteCard({
    super.key,
    required this.producto,
    required this.usuario,
  });

  final CarritoProductosService carritoService = CarritoProductosService();

  Future<void> agregarCarrito(BuildContext context) async {

    if(producto.id == null) return;

    try {
      final nuevoProducto = CarritoProducto(idCarrito: usuario.idCarrito!, idProducto: producto.id!, cantidad: 1);
      await carritoService.agregarProductoCarrito(nuevoProducto);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${producto.nombre} agregado al carrito")));
    } catch(error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetalleProductosScreen(producto: producto, usuario: usuario)));
      },
      child: Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: producto.imagenUrl != null ? Image.network(producto.imagenUrl!, height: 140, width: double.infinity, fit: BoxFit.cover)
                : Container(
                height: 140, color: Colors.grey[300], child: const Icon(Icons.image, size: 40),
                ),
              ),

              Positioned(
                bottom: 5,
                right: 5,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6
                      )
                    ]
                  ),
                  child: IconButton(
                    onPressed: () => agregarCarrito(context), 
                    icon: const Icon(Icons.add_shopping_cart, color: Colors.blue, size: 15)
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(producto.nombre, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),

                if(producto.nombreTienda != null)
                Row(
                  children: [
                    Flexible(child: Text(producto.nombreTienda!, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Colors.blueGrey))),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, size: 14, color: Colors.blue)
                  ],
                ),
                const SizedBox(height: 8),
                Text("\$${producto.precioUnidad.toStringAsFixed(0)}", style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 76, 119, 175), fontWeight: FontWeight.bold)),
                ]
              )
            ),
          ],
        ),
      )
    );
  }
} 