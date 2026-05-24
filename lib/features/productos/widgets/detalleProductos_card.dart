import 'package:flutter/material.dart';
import 'package:tienda_pc/models/productos.dart';

class DetalleproductosCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback agregarCarrito;
  
  const DetalleproductosCard({
    super.key,
    required this.producto,
    required this.agregarCarrito
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(producto.nombreTienda != null && producto.nombreTienda!.isNotEmpty)
          Row(
            children: [
              const Icon(Icons.store, size: 18, color: Colors.grey),
              const SizedBox(width: 5),
              Text(producto.nombreTienda!, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))
            ],
          ),
          const SizedBox(height: 14),
          Text(producto.nombre, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

          const SizedBox(height: 15),
          Text("\$${producto.precioUnidad.toStringAsFixed(0)}", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),

          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(18)
                ),
                child: Text(producto.categoriaMostrada, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
              ),
              
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(18)),
                child: Text("${producto.unidades} disponibles", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600)), 
              )
            ],
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))
              ),
              onPressed: agregarCarrito,
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text("Agregar al carrito", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),

          const SizedBox(height: 30),
          const Text("Descripción", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

          const SizedBox(height: 10),
          Text(producto.descripcion ?? "Sin descripción", style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87))
        ],
      ),
    );
  }
}