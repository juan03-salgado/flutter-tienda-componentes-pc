import 'package:flutter/material.dart';

class UsuariosForm extends StatelessWidget {
  final TextEditingController nombreController;
  final TextEditingController emailController;
  final TextEditingController contrasenaController;
  final VoidCallback guardar;

  const UsuariosForm({
    super.key,
    required this.nombreController,
    required this.emailController,
    required this.contrasenaController,
    required this.guardar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: const [
              Icon(Icons.badge_outlined, size: 50),
              SizedBox(height: 5),
              Text("Perfil usuario",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        SizedBox(height: 20),

        TextField(
          controller: nombreController,
          decoration: const InputDecoration(labelText: "Nombre"),
        ),
        
        TextField(
          controller: emailController,
          decoration: const InputDecoration(labelText: "Email"),
        ),

        TextField(
          controller: contrasenaController,
          obscureText: true,
          decoration: const InputDecoration(labelText: "Nueva Contraseña"),
        ),

        const SizedBox(height: 40),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: guardar, 
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 114, 116, 231),
              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
              elevation: 2
            ),
            child: const Text("Guardar", style: TextStyle(color: Colors.white))))
        ],
      );
  }
}