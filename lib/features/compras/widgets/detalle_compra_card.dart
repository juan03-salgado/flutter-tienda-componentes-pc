import 'package:flutter/material.dart';
import 'package:tienda_pc/features/soporteTecnico/incidencias/screens/crear_incidencia_screen.dart';
import 'package:tienda_pc/models/detalleCompra.dart';
import 'package:tienda_pc/models/productos.dart';
import 'package:tienda_pc/models/usuarios.dart';

class DetalleCompraCard extends StatelessWidget{
  final Detallecompra detalle;
  final Usuario? usuario;
  final String estadoCompra;

  const DetalleCompraCard({
    super.key,
    required this.detalle,
    this.usuario,
    required this.estadoCompra
  });

  @override
  Widget build(BuildContext context) {

    final producto = Producto(
      id: detalle.idProducto,
      nombre: detalle.producto, 
      descripcion: "", 
      idCategoria: null, 
      categoriaNombre: detalle.categoria, 
      precioUnidad: detalle.precioTotal,
      imagenUrl: detalle.imagenUrl, 
      unidades: detalle.cantidad,
      id_vendedor: null
    );

    final bool reportar = usuario?.rol == 3 && estadoCompra == "COMPLETADA";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsetsGeometry.all(10),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.antiAlias,
              child: (detalle.imagenUrl != null && detalle.imagenUrl!.trim().isNotEmpty) ? Image.network(detalle.imagenUrl!, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported)) : const Icon(Icons.image_not_supported)
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(detalle.producto, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text("Cantidad: ${detalle.cantidad}"),
                  Text("Subtotal: \$${detalle.precioTotal.toStringAsFixed(2)}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                ],
              )
            ),
            if(reportar) 
            TextButton.icon(
              icon: const Icon(Icons.report_problem_rounded, color: Colors.red, size: 18),
              label: const Text("Reportar", style: TextStyle(fontSize: 12)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CrearIncidenciaScreen(usuario: usuario!, producto: producto)));
              },
            )
          ],
        ),
      ),
    );
  }
}