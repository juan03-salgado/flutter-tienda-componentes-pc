import 'package:flutter/material.dart';
import 'package:tienda_pc/screens/admin/home_screen.dart';
import 'package:tienda_pc/screens/auth/login_screen.dart';
import 'package:tienda_pc/screens/auth/register_screen.dart';
import 'package:tienda_pc/screens/productos/productos_screen.dart';

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
        '/login': (context) => LoginScreen(),
        '/home-admin': (context) => HomeScreen(),
        '/registro': (context) => RegisterScreen(),
        '/productos': (context) => ProductosScreen(rol: 3),
      },
    );
  }
}