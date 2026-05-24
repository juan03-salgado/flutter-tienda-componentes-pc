import 'package:flutter/material.dart';
import 'package:tienda_pc/features/usuarios/widgets/usuarios_card.dart';
import 'package:tienda_pc/models/usuarios.dart';
import 'package:tienda_pc/features/usuarios/screens/usuarios_formulario_screen.dart';
import 'package:tienda_pc/services/usuario.service.dart';

class UsuariosListScreen extends StatefulWidget {
  const UsuariosListScreen({super.key});

  @override
  State<UsuariosListScreen> createState() => _UsuariosListScreenState();
}

class _UsuariosListScreenState extends State<UsuariosListScreen> {
  
  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  final UsuarioService usuarioService = UsuarioService();

  List<Usuario> usuarios = [];

  Future<void> cargarUsuarios() async {
    try {
      final usuariosCargados = await usuarioService.getUsuarios();
      setState(() {
        usuarios = usuariosCargados;
      });
    } catch(error){
      print("Error al cargar los usuarios: $error");
    }
  }

  Future<void> eliminarUsuario(int id) async {
    await usuarioService.eliminarUsuario(id);
    cargarUsuarios();
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuarios"),
      ),
      body: usuarios.isEmpty ? const Center(child: CircularProgressIndicator())
      : ListView.builder(itemCount: usuarios.length, itemBuilder: (context, index) {
        final usuario = usuarios[index];

        return UsuariosCard(
          usuario: usuario,
          eliminar: () async {
            final confirmar = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
              title: const Text("Confirmar"),
              content: const Text("¿Desea eliminar este usuario?"),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Eliminar"))
              ],
            ));

            if(confirmar == true){
              await eliminarUsuario(usuario.id!);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Usuario eliminado correctamente")));
            }
          },
          editar: () async {
            final resultado = await Navigator.push(context, MaterialPageRoute(builder: (context) => UsuariosFormularioScreen(usuario: usuario)));
            if (resultado == true) {
              cargarUsuarios();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Usuario actualizado correctamente")));
            }
          },
        );
      }),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        final resultado = await Navigator.push(context, MaterialPageRoute(builder: (context) => UsuariosFormularioScreen()));
        if(resultado == true) {
          cargarUsuarios();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Usuario creado correctamente"),));
        }
      },
      child: const Icon(Icons.add),
      ),
    );
  }
}