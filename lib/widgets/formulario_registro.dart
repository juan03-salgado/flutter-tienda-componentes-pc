import 'package:flutter/material.dart';

class FormularioRegistro extends StatelessWidget {

  final GlobalKey<FormState> formkey;
  final TextEditingController nombreController;
  final TextEditingController emailController;
  final TextEditingController contrasenaController;
  final TextEditingController confirmarContrasenaController;
  final VoidCallback registrar;
  final bool verContrasena;
  final VoidCallback mostrarContrasena;

  const FormularioRegistro({
    super.key,
    required this.nombreController,
    required this.emailController,
    required this.contrasenaController,
    required this.confirmarContrasenaController,
    required this.formkey,
    required this.registrar,
    this.verContrasena = false,
    required this.mostrarContrasena,
  });

  @override 
  Widget build(BuildContext context){
    return Form(
    key: formkey, 
    child: SingleChildScrollView(  
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          controller: nombreController,
          decoration: const InputDecoration(label: Text("Nombre"), border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
          validator: (value) => value!.isEmpty ? "Campo requerido" : null,
        ),
        SizedBox(height: 20),
    
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(label: Text("email"), border: OutlineInputBorder(), prefixIcon: Icon(Icons.email_outlined)),
          validator: (value){
            if(value == null || value.isEmpty) return "Campo requerido";
            if(value.contains("@")) return "Email invalido";
            return null;
          },
        ),
        SizedBox(height: 20),
    
        TextFormField(
          controller: contrasenaController,
          obscureText: !verContrasena,
          decoration: InputDecoration(label: Text("contraseña"), border: const OutlineInputBorder(), prefixIcon: Icon(Icons.lock_outline), 
          suffixIcon: IconButton(icon: Icon(verContrasena ? Icons.visibility : Icons.visibility_off), onPressed: mostrarContrasena)),
          validator: (value) => value!.isEmpty ? "Campo requerido" : null,
        ),
        SizedBox(height: 20),
    
        TextFormField(
          controller: confirmarContrasenaController,
          obscureText: !verContrasena,
          decoration: InputDecoration(label: Text("Confirmar contraseña"), border: const OutlineInputBorder(), prefixIcon: Icon(Icons.lock_reset)),
          validator: (value) {
            if(value == null || value.isEmpty) return "Campo requerido";
            if(value != contrasenaController.text) return "Las contraseñas no coinciden";
            return null;
          },
        ),
        SizedBox(height: 20),
        SizedBox(width: double.infinity,child: ElevatedButton(onPressed: registrar, child: const Text("Registrarse"))
        ),
    
      ],
    ),
    ),
    );
  }
}