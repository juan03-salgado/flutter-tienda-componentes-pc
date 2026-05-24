import 'package:flutter/material.dart';
import 'package:tienda_pc/features/home/usuarios/widgets/detalle_compra_cliente.dart';
import 'package:tienda_pc/models/compras.dart';
import 'package:tienda_pc/models/usuarios.dart';
import 'package:tienda_pc/services/compras.service.dart';

class VentasvendedorCard extends StatelessWidget {
  final Compras compras;
  final Usuario usuario;
  final String titulo;
  final VoidCallback actualizar;

  const VentasvendedorCard({
    super.key,
    required this.compras,
    required this.usuario,
    required this.titulo,
    required this.actualizar
  });

  Color _colorEstado(String estado) {
    switch (estado) {
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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.receipt_long, color: Colors.blue),
        ),
        title: Text("$titulo #${compras.idCompra}", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Cliente: ${compras.cliente}"),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _colorEstado(compras.estado).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20)),
                  child: Text(compras.estado, style: TextStyle(color: _colorEstado(compras.estado), fontWeight: FontWeight.bold, fontSize: 12)),
              )
            ],
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {

            await ComprasService().actualizarEstado(compras.idCompra, value);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Estado actualizado a $value")));
            actualizar();
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: "COMPLETADA", child: Text("COMPLETADA")),
            const PopupMenuItem(value: "CANCELADA", child: Text("CANCELADA")),
          ],
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => DetalleCompraCliente(compra: compras, usuario: usuario)));
        },
      ),
    );
  }
}