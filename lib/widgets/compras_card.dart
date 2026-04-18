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
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text("Compra #${compras.idCompra}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Cliente: ${compras.cliente}"),
            Text("Total: \$${total.toStringAsFixed(2)}"),
          ],
        ),
        trailing: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              value: compras.estado,
              isDense: true,
              items: const [
                DropdownMenuItem(value: "PENDIENTE", child: Text("PENDIENTE")),
                DropdownMenuItem(value: "COMPLETADA", child: Text("COMPLETADA")),
                DropdownMenuItem(value: "CANCELADA", child: Text("CANCELADA"))
              ],
              onChanged: (value) {
                if(value != null){
                  cambiarEstado(value);
                }
              },
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: verDetalle, icon: Icon(Icons.visibility)),
                IconButton(onPressed: eliminar, icon: Icon(Icons.delete, color: Colors.red)),
              ],
            )
          ],
        ),
      ),
    ),
    );
  }
}