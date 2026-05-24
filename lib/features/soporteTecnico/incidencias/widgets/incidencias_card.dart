import 'package:flutter/material.dart';
import 'package:tienda_pc/features/soporteTecnico/serviciosTecnicos/screens/crearServicios_screen.dart';
import 'package:tienda_pc/models/incidencias.dart';
import 'package:tienda_pc/models/usuarios.dart';

class IncidenciasCard extends StatelessWidget {
  final Incidencia incidencia;
  final Usuario usuario;
  final VoidCallback eliminar;
  final Function(String, String) cambiarEstado;
  final bool esCliente;

  const IncidenciasCard({
    super.key,
    required this.incidencia,
    required this.usuario,
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
      case 'RESUELTA':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final solicitarServicio = esCliente && incidencia.estado != "RESUELTA";

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.report_problem, size: 40),
              title: Text(incidencia.producto.nombre),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Usuario: ${incidencia.usuario.nombre}"),
                  Text("Descripción: ${incidencia.descripcion}", maxLines: 2, overflow: TextOverflow.ellipsis,),
                  Text("Estado actual:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                    decoration: BoxDecoration(color: _colorEstado(incidencia.estado).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text(incidencia.estado, style: TextStyle(color: _colorEstado(incidencia.estado), fontWeight: FontWeight.bold, fontSize: 12)),
                  )
                ],
              ),
              trailing: esCliente ? null : PopupMenuButton<String>(
                onSelected: (value) async {
                  if(value == "ELIMINAR"){
                    eliminar();
                  } else {

                    final mensajeController = TextEditingController();
                    final mensaje = await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Actualizar estado"),
                        content: TextField(
                          controller: mensajeController,
                          maxLines: 2,
                          decoration: const InputDecoration(hintText: "Mensaje para el cliente (opcional)"),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancelar"),
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
                  const PopupMenuItem(value: "PENDIENTE", child: Text("PENDIENTE")),
                  const PopupMenuItem(value: "EN PROCESO", child: Text("EN PROCESO")),
                  const PopupMenuItem(value: "RESUELTA", child: Text("RESUELTA")),
                  const PopupMenuItem(value: "ELIMINAR", child: Text("ELIMINAR", style: TextStyle(color: Colors.red))),
                ],
              ),
            ),
            if(solicitarServicio)
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.build),
                label: const Text("Solicitar soporte tecnico"),
                onPressed: () async {
                  final creado = await Navigator.push(context, MaterialPageRoute(builder: (context) => CrearserviciosScreen(usuario: incidencia.usuario, producto: incidencia.producto)));
                  if(creado == true){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Servicio creado desde incidencia")));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );  
  }
}