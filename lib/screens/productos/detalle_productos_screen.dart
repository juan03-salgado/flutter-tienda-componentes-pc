import 'package:flutter/material.dart';
import 'package:tienda_pc/models/carritoProducto.dart';
import 'package:tienda_pc/models/productos.dart';
import 'package:tienda_pc/services/carritoProductos.service.dart';

class DetalleProductosScreen extends StatelessWidget {
  final Producto producto;

  const DetalleProductosScreen({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(producto.nombre),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 250,
              child: producto.imagenUrl != null ? Image.network(producto.imagenUrl!, fit: BoxFit.cover) : const Icon(Icons.image, size: 100),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(producto.nombre, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Text("Categoria: ${producto.categoriaNombre ?? 'Sin categoria'}", style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  Text("unidades: ${producto.unidades}", style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  Text("Precio: \$${producto.precioUnidad.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, color: Colors.green)),
                  const SizedBox(height: 20),
                  Text("Descripción: ${producto.descripcion}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 40),

                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton.icon(onPressed: () async {
                      try{
                        final carritoProductosService = CarritoProductosService();

                        final agregarProducto = CarritoProducto(
                          id: null,
                          idCarrito: 1,
                          idProducto: producto.id!,
                          cantidad: 1,
                          producto: producto
                        );  
                        await carritoProductosService.agregarProductoCarrito(agregarProducto);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Producto agregado al carrito")));
                      } catch(error) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al agregar al carrito")));
                      }
                    }, 
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text("Agregar al carrito"),
                  ),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}