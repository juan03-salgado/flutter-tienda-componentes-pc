import 'package:flutter/material.dart';
import 'package:tienda_pc/auth/widgets/formulario_registro.dart';
import 'package:tienda_pc/services/auth.service.dart';

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
  bool loading = false;
  
  final authService = AuthService();

  Future<void> registrarUsuario() async {
    if(!formKey.currentState!.validate()) return;

    try {
      await authService.register(nombreController.text, emailController.text, contrasenaController.text);
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Usuario registrado correctamente")));
      Navigator.pop(context);
      
    } catch(error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error ${error.toString()}"))
      );
    } finally {
      setState(() => loading = false);
    }
  }

  void mostrarContrasena(){
    setState(() {
      verContrasena = !verContrasena;
    });
  }

  @override
  void dispose() {
    nombreController.dispose();
    emailController.dispose();
    contrasenaController.dispose();
    confirmarContrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
          child: FormularioRegistro(
            formkey: formKey,
            nombreController: nombreController, 
            emailController: emailController, 
            contrasenaController: contrasenaController, 
            confirmarContrasenaController: confirmarContrasenaController, 
            registrar: registrarUsuario, 
            verContrasena: verContrasena, 
            mostrarContrasena: mostrarContrasena,
            loading: loading,
          ),
        ),
      );
 }
}