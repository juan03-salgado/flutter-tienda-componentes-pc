import 'package:flutter/material.dart';

class FormularioLogin extends StatelessWidget{

  final GlobalKey<FormState> formKey;
  final TextEditingController nombreController;
  final TextEditingController contrasenaController;
  final VoidCallback registrarse;
  final VoidCallback login;
  final bool verContrasena;
  final VoidCallback mostrarContrasena;

  const FormularioLogin({
    super.key,
    required this.formKey,
    required this.nombreController,
    required this.contrasenaController,
    required this.login,
    required this.registrarse,
    this.verContrasena = false,
    required this.mostrarContrasena
  });

  @override 
  Widget build(BuildContext context){
    return Form(
      key: formKey,
      child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextFormField(
            controller: nombreController,
            decoration: const InputDecoration(labelText: 'Nombre de usuario', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)), 
            validator: (value) => value!.isEmpty ? "Campo requerido" : null,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: contrasenaController,
            obscureText: !verContrasena,
            decoration: InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock_outline), 
            suffixIcon: IconButton(icon: Icon(verContrasena ? Icons.visibility: Icons.visibility_off), onPressed: mostrarContrasena)), 
            validator: (value) => value!.isEmpty ? "Campo requerido" : null,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: ElevatedButton(onPressed: login, child: const Text("Login"))),
              const SizedBox(height: 20),
              Expanded(child: ElevatedButton(onPressed: registrarse, child: const Text("Registrarse"))),
            ],
          )
        ],
      ),
    ),
  );
  }
}