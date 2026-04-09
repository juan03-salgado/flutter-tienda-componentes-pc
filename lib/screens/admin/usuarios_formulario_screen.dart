import 'package:flutter/material.dart';
import 'package:tienda_pc/models/usuarios.dart';
import 'package:tienda_pc/services/usuario.service.dart';

class UsuariosFormularioScreen extends StatefulWidget {
  final Usuario? usuario;

  const UsuariosFormularioScreen({super.key, this.usuario});

  @override
  State<UsuariosFormularioScreen> createState() => _UsuariosFormularioScreenState();
}

class _UsuariosFormularioScreenState extends State<UsuariosFormularioScreen> {

  final UsuarioService usuarioService = UsuarioService();
  final formKey = GlobalKey<FormState>();
  bool mostrarContrasena = false;

  final nombreController = TextEditingController();
  final emailController = TextEditingController();
  final contrasenaController = TextEditingController();
  final rolController = TextEditingController();
  
  @override
  void initState() {
    super.initState();

    if(widget.usuario != null){
      nombreController.text = widget.usuario!.nombre;
      emailController.text = widget.usuario!.email;
      contrasenaController.text = widget.usuario!.contrasena;
      rolController.text = widget.usuario!.rol.toString();
    }
  }

  Future<void> guardarUsuario() async {
      final int rol = rolController.text.isNotEmpty ? int.parse(rolController.text) : 3;

      if(!formKey.currentState!.validate()) return;

      final usuarioEditado = Usuario(
        id: widget.usuario?.id,
        nombre: nombreController.text,
        email: emailController.text,
        contrasena: contrasenaController.text,
        rol: rol 
      );

      try {
        if(widget.usuario == null){
          await usuarioService.crearUsuario(usuarioEditado);
        } else {
          await usuarioService.actualizarUsuario(usuarioEditado);
        }
        
        Navigator.pop(context, true);

      } catch(error){
        print("Error al guardar el usuario: $error");
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ocurrió un error al guardar el usuario")));
      }
  }

  @override  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.usuario == null ? "Crear Usuario" : "Editar Usuario"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
          children: [
            TextFormField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: "Nombre", border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),  validator: (value) => value!.isEmpty ? "Campo requerido" : null,
            ),
              const SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder(), prefixIcon: Icon(Icons.email_outlined)), validator: (value) => value!.isEmpty ? "Campo requerido" : null,
            ),
              const SizedBox(height: 20),
            TextFormField(
              controller: contrasenaController,
              obscureText: !mostrarContrasena,
              decoration: InputDecoration(labelText: "Contraseña", border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock_outline), suffixIcon: IconButton(icon: Icon(mostrarContrasena ? Icons.visibility : Icons.visibility_off), 
              onPressed: () => setState(() => mostrarContrasena = !mostrarContrasena))), validator: (value) => value!.isEmpty ? "Campo requerido": null,
            ),
              const SizedBox(height: 20),
            TextFormField(
              controller: rolController,
              decoration: const InputDecoration(labelText: "Rol", border: OutlineInputBorder(), prefixIcon: Icon(Icons.account_circle_outlined)), keyboardType: TextInputType.number, validator: (value) => value!.isEmpty ? "Campo requerido": null,
            ),
              const SizedBox(height: 20),
            ElevatedButton(onPressed: guardarUsuario, child: Text(widget.usuario == null ? "Crear" : "Guardar"))
            ]
          ),
        ),
      ),
    ),
    );
  }
}