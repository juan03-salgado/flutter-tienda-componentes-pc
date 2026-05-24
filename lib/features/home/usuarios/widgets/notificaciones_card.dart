import 'package:flutter/material.dart';
import 'package:tienda_pc/models/usuarios.dart';
import 'package:tienda_pc/services/notificaciones.service.dart';

class NotificacionesCard extends StatefulWidget {
  final Usuario usuario;
  final VoidCallback onTap;
  
  const NotificacionesCard({
    super.key,
    required this.usuario,
    required this.onTap
  });

  @override
  State<NotificacionesCard> createState() => _NotificacionesCardState();
}

class _NotificacionesCardState extends State<NotificacionesCard> {

  final NotificacionesService notificacionesService = NotificacionesService();
  int total = 0;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    try {
      final resultado = await notificacionesService.contarNoLeidas(widget.usuario.id!);

      if(mounted){
        setState(() => total = resultado);
      }

    } catch(error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () async {
            widget.onTap();
            await Future.delayed(const Duration(milliseconds: 500));
            cargar();
          },
        ),

        if(total > 0)
        Positioned(
          right: 6,
          top: 6,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            child: Text("$total", style: const TextStyle(color: Colors.white, fontSize: 10)),
          ),
        )
      ],
    );
  }
}