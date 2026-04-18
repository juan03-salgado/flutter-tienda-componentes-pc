import 'package:flutter/material.dart';
import 'package:tienda_pc/models/usuarios.dart';

class UsuariosCard extends StatelessWidget {
  final Usuario usuario;
  final VoidCallback eliminar;
  final VoidCallback editar;

  const UsuariosCard({
    super.key, 
    required this.usuario, 
    required this.eliminar, 
    required this.editar
  });

  @override 
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(usuario.nombre),
        subtitle: Text(usuario.email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Rol: ${usuario.rol}"),
            IconButton(icon: const Icon(Icons.edit), onPressed: editar, style: IconButton.styleFrom(foregroundColor: Colors.blue)),
            IconButton(icon: const Icon(Icons.delete), onPressed: eliminar, style: IconButton.styleFrom(foregroundColor: Colors.red)),
          ],
        ),
      ),
    );
  }
}