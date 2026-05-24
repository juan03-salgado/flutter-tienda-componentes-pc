import 'package:flutter/material.dart';
import 'package:tienda_pc/models/notificacion.dart';
import 'package:tienda_pc/models/usuarios.dart';
import 'package:tienda_pc/services/notificaciones.service.dart';

class NotificacionesScreen extends StatefulWidget {
  final Usuario usuario;

  const NotificacionesScreen({super.key, required this.usuario});

  @override
  State<NotificacionesScreen> createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {

  final NotificacionesService notificacionesService = NotificacionesService();
  List<Notificacion> notificaciones = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    try {
      final lista = await notificacionesService.getNotificaciones(widget.usuario.id!);
      if(!mounted) return;

      setState(() {
        notificaciones = lista;
        loading = false;
      });

    } catch(error){
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $error")));
    }
  }

  Future<void> marcarLeida(int id) async {
    await notificacionesService.marcarLeida(id);
    await cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notificaciones"),
      ),
      body: loading ? const Center(child: CircularProgressIndicator()) 
      : notificaciones.isEmpty ? const Center(child: Text("No tienes notificaciones"))
      : ListView.builder (
        itemCount: notificaciones.length,
        itemBuilder: (context, index) {
          final notificacion = notificaciones[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: Icon(notificacion.leido ? Icons.check_circle : Icons.notifications_active, color: notificacion.leido ? Colors.green : Colors.orange),
              title: Text(notificacion.mensaje, style: TextStyle(fontWeight: notificacion.leido ? FontWeight.normal : FontWeight.bold)),
              subtitle: Text(notificacion.fechaFormateada),
              onTap: () async {
                if(!notificacion.leido){
                  await marcarLeida(notificacion.id!);
                }
              },
            ),
          );
        },  
      )
    );
  }
}