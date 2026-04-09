import 'package:flutter/material.dart';
import 'package:tienda_pc/services/auth.service.dart';
import 'package:tienda_pc/widgets/formulario_registro.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final nombreController = TextEditingController();
  final emailController = TextEditingController();
  final contrasenaController = TextEditingController();
  final confirmarContrasenaController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool verContrasena = false;
  
  final autService = AuthService();

  Future<void> registrarUsuario() async {
    if(!formKey.currentState!.validate()) return;

    try {
      await autService.register(nombreController.text, emailController.text, contrasenaController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Usuario registrado correctamente")));
      Navigator.pop(context);
      
    } catch(error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error ${error.toString()}"))
      );
    }
  }

  void mostrarContrasena(){
    setState(() {
      verContrasena = !verContrasena;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        centerTitle: true,
      ),
      body: Padding(padding: const EdgeInsets.all(15.0),
      child: FormularioRegistro(
        formkey: formKey,
        nombreController: nombreController, 
        emailController: emailController, 
        contrasenaController: contrasenaController, 
        confirmarContrasenaController: confirmarContrasenaController, 
        registrar: registrarUsuario, 
        verContrasena: verContrasena, 
        mostrarContrasena: mostrarContrasena),
      ),
    );
 }
}