import 'package:flutter/material.dart';
import 'package:tienda_pc/models/serviciosTecnicos.dart';

class ServiciostecnicosCard extends StatelessWidget {
  final Serviciostecnicos servicio;
  final VoidCallback eliminar;
  final Function(String, String) cambiarEstado;
  final bool esCliente;

  const ServiciostecnicosCard({
    super.key,
    required this.servicio,
    required this.eliminar,
    required this.cambiarEstado,
    required this.esCliente
  });

  Color _colorEstado(String estado) {
    switch (estado) {
      case 'PENDIENTE':
        return Colors.orange;
      case 'EN PROCESO':
        return Colors.blue;
      case 'FINALIZADO':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: const Icon(Icons.build, size: 40),
        title: Text(servicio.tipoServicio),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Solicitado por: ${servicio.usuario.nombre}'),
            Text('Descripción: ${servicio.descripcion}'),
            Text('Fecha: ${servicio.fechaFormateada}'),
            Text('Producto: ${servicio.producto!.nombre}', maxLines: 1),
            const Text("Estado actual:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            Container(
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: _colorEstado(servicio.estado).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20)
              ),
              child: Text(servicio.estado, style: TextStyle(color: _colorEstado(servicio.estado), fontWeight: FontWeight.bold, fontSize: 12)),
            )
          ],
        ),
        trailing: esCliente ? null : PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'ELIMINAR') {
              final confirmar = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Confirmar"),
                  content: const Text("¿Desea eliminar este servicio?"),
                actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Eliminar")),
                  ],
                ),
              );
              if(confirmar == true){
                eliminar();
              } 
              } else {
                
                final mensajeController = TextEditingController();
                final mensaje = await showDialog<String>(
                  context: context,
                  builder:(context) => AlertDialog(
                    title: const Text("Actualizar estado"),
                    content: TextField(
                      controller: mensajeController,
                      maxLines: 2,
                      decoration: const InputDecoration(hintText: "Mensaje para cliente (Opcional)"),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context), 
                        child: const Text("Cancelar")
                      ),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, mensajeController.text);
                      }, 
                      child: const Text("Enviar")
                      )
                    ],
                  ),
                );
                cambiarEstado(value, mensaje ?? "");
              }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'PENDIENTE', child: Text('PENDIENTE')),
            const PopupMenuItem(value: 'EN PROCESO', child: Text('EN PROCESO')),
            const PopupMenuItem(value: 'FINALIZADO', child: Text('FINALIZADO')),
            const PopupMenuItem(value: 'ELIMINAR', child: Text('ELIMINAR', style: TextStyle(color: Colors.red),)),
          ],
        ),
      ),
    );
  }
}