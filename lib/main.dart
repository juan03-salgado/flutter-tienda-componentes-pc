import 'package:flutter/material.dart';
import 'package:tienda_pc/auth/screens/login_screen.dart';
import 'package:tienda_pc/auth/screens/register_screen.dart';
import 'package:tienda_pc/features/compras/screens/compras_list_screen.dart';
import 'package:tienda_pc/features/home/admin/screens/home_admin_screen.dart';
import 'package:tienda_pc/features/home/usuarios/screens/clientes_main_screen.dart';
import 'package:tienda_pc/features/home/vendedor/screens/vendedor_main_screen.dart';
import 'package:tienda_pc/features/productos/screens/productos_screen.dart';
import 'package:tienda_pc/features/usuarios/screens/usuarios_list_screen.dart';
import 'package:tienda_pc/models/usuarios.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/registro': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/home-admin': (context) => HomeAdminScreen(),
        '/clientes-main': (context) => ClientesMainScreen(),
        '/vendedor-main': (context) => VendedorMainScreen(),
        '/usuarios': (context) => UsuariosListScreen(),
        '/productos': (context) {
          final usuario = ModalRoute.of(context)!.settings.arguments as Usuario;
          return ProductosScreen(rol: usuario.rol, vista: true, usuario: usuario);
        },
        '/compras': (context) => ComprasListScreen(),
      },
    );
  }
}