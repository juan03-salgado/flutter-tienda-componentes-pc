import 'package:flutter/material.dart';
import 'package:tienda_pc/models/compras.dart';

class ComprasCard extends StatelessWidget {
  final Compras compras;
  final VoidCallback verDetalle;
  final VoidCallback eliminar;
  final Function(String) cambiarEstado;

  const ComprasCard({
    super.key,
    required this.compras,
    required this.verDetalle,
    required this.eliminar,
    required this.cambiarEstado,
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
    final total = compras.productos.fold(0.0, (sum, item) => sum + item.precioTotal);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Compra: #${compras.idCompra}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: _colorEstado(compras.estado).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8)
                  ),
                  child: Text(compras.estado, style: TextStyle(color: _colorEstado(compras.estado), fontWeight: FontWeight.bold, fontSize: 12)),
                )
              ],
            ),
              const SizedBox(height: 8),

              Text("Cliente: ${compras.cliente}"),
              Text("Total: \$${total.toStringAsFixed(2)}"),

              const SizedBox(height: 10),

             Row(
              children: [
                DropdownButton<String>(
                  value: compras.estado.isEmpty ? "PENDIENTE" : compras.estado,
                  items: const [
                    DropdownMenuItem(value: "PENDIENTE", child: Text("PENDIENTE")),
                    DropdownMenuItem(value: "COMPLETADA", child: Text("COMPLETADA")),
                    DropdownMenuItem(value: "CANCELADA", child: Text("CANCELADA")),
                  ], 
                  onChanged: (value) {
                    if(value != null){
                      cambiarEstado(value);
                    }
                  },
                ),
                const Spacer(),

                IconButton(
                  onPressed: verDetalle, 
                  icon: const Icon(Icons.visibility)
                ),
                IconButton(
                  onPressed: eliminar, 
                  icon: const Icon(Icons.delete, color: Colors.red,)
                )
              ],
             )
          ],
        ),        
    ),
    );
  }
}