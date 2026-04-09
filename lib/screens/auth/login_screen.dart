import 'package:flutter/material.dart';
import 'package:tienda_pc/services/auth.service.dart';
import 'package:tienda_pc/widgets/formulario_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  final nombreController = TextEditingController();
  final contrasenaController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool verContrasena = false;

  final authService = AuthService();

  Future<void> inicioSesion() async {
    if(!formKey.currentState!.validate()) return;

  try {
      final usuario = await authService.login(nombreController.text, contrasenaController.text);

      if(usuario.rol == 1){
        Navigator.pushReplacementNamed(context, "/home-admin");
      } else if (usuario.rol == 2) {
        Navigator.pushReplacementNamed(context, "/home-vendedor");
      } else if (usuario.rol == 3){
        Navigator.pushReplacementNamed(context, "/home-cliente");
      }
    } catch(error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error ${error.toString()}")));
    }
  }


  void mostrarContrasena() {
    setState(() {
      verContrasena = !verContrasena;
    });
  }

  void registrarse() {
    Navigator.pushNamed(context, '/registro');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
          child: FormularioLogin(
            formKey: formKey,
            nombreController: nombreController, 
            contrasenaController: contrasenaController, 
            login: inicioSesion, 
            registrarse: registrarse, 
            verContrasena: verContrasena, 
            mostrarContrasena: mostrarContrasena),
          ),
      );
  }
}