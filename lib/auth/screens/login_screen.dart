import 'package:flutter/material.dart';
import 'package:tienda_pc/auth/widgets/formulario_login.dart';
import 'package:tienda_pc/services/auth.service.dart';

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
  bool loading = false;

  final authService = AuthService();

  Future<void> inicioSesion() async {
    if(!formKey.currentState!.validate()) return;

    setState(() => loading = true);

  try {
      final usuario = await authService.login(nombreController.text.trim(), contrasenaController.text.trim());

      if(usuario.rol == 1){
        Navigator.pushReplacementNamed(context, "/home-admin", arguments: usuario);
      } else if (usuario.rol == 2) {
        Navigator.pushReplacementNamed(context, "/vendedor-main", arguments: usuario);
      } else if (usuario.rol == 3){
        Navigator.pushReplacementNamed(context, "/clientes-main", arguments: usuario);
      }
    } catch(error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString().replaceAll("Exception: ", ""))));    
    } finally{
      setState(() => loading = false);
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
  void dispose() {
    nombreController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
          child: FormularioLogin(
            formKey: formKey,
            nombreController: nombreController, 
            contrasenaController: contrasenaController, 
            login: inicioSesion, 
            registrarse: registrarse, 
            verContrasena: verContrasena,
            loading: loading, 
            mostrarContrasena: mostrarContrasena),
        ),
      );
  }
}