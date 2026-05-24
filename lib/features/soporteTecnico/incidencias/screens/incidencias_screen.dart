import 'package:flutter/material.dart';
import 'package:tienda_pc/models/incidencias.dart';
import 'package:tienda_pc/models/usuarios.dart';
import 'package:tienda_pc/services/incidencias.service.dart';
import 'package:tienda_pc/features/soporteTecnico/incidencias/widgets/incidencias_card.dart';

class IncidenciasScreen extends StatefulWidget {
  final Usuario usuario;

  const IncidenciasScreen({super.key, required this.usuario});

  @override
  State<IncidenciasScreen> createState() => _IncidenciasScreenState();
}

class _IncidenciasScreenState extends State<IncidenciasScreen> {

  final IncidenciasService incidenciasService = IncidenciasService();
  late Future<List<Incidencia>> incidencias;

  @override
  void initState() {
    super.initState();
    cargarIncidencias();
  }
  
  void cargarIncidencias(){
    setState(() {
      if(widget.usuario.rol == 3){
        incidencias = incidenciasService.getIncidenciasCliente(widget.usuario.id!);
      } else if(widget.usuario.rol == 2){
        incidencias = incidenciasService.getIncidenciasVendedor(widget.usuario.id!);
      } else {
        incidencias = incidenciasService.getIncidencias();
      }
    });
  }

  Future<void> eliminarIncidencia(int id) async {
    await incidenciasService.eliminarIncidencia(id);
    cargarIncidencias();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Incidencia eliminada")));
  }

  Future<void> cambiarEstado(int id, String estado, String mensaje) async {
    await incidenciasService.actualizarEstado(id, estado, mensaje);
    cargarIncidencias();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("estado de incidencia actualizado")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List <Incidencia>>(
        future: incidencias,
        builder:(context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){
            return const Center(child: Text("Error al cargar las incidencias"));
          }

          final incidencias = snapshot.data ?? [];

          if(incidencias.isEmpty){
            return const Center(child: Text("No hay incidencias registradas"));
          }

          return ListView.builder(
            itemCount: incidencias.length,
            itemBuilder:(context, index) {
              final incidencia = incidencias[index];
              return IncidenciasCard(
                incidencia: incidencia,
                usuario: widget.usuario,
                esCliente: widget.usuario.rol == 3,
                eliminar: () async {
                  final confirmar = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Confirmar"),
                      content: const Text("¿Desea eliminar esta incidencia?"),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Eliminar")),
                      ],
                    ),
                  );
                  if(confirmar == true){
                    eliminarIncidencia(incidencia.id!);
                  }
                },
                  cambiarEstado: (estado, mensaje) => cambiarEstado(incidencia.id!, estado, mensaje),
              );
            },
          );
        },
      )
    );
  }
}