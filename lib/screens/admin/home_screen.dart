import 'package:flutter/material.dart';
import 'package:tienda_pc/screens/admin/carrito_screen.dart';
import 'package:tienda_pc/screens/admin/compras_list_screen.dart';
import 'package:tienda_pc/screens/admin/usuarios_list_screen.dart';
import 'package:tienda_pc/screens/auth/login_screen.dart';
import 'package:tienda_pc/screens/productos/productos_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(icon: Icon(Icons.logout, color: Colors.red),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
          )
        ],
      ),
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const UsuariosListScreen()));
            }, 
            child: const Text("Ver Usuarios")
            ),

            SizedBox(height: 20),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductosScreen(rol: 1)),
              );
            },
            child: const Text("Ver Productos"),
            ),

            SizedBox(height: 20),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CarritoScreen()),
              );
            },
            child: const Text("Ver Carritos"),
            ),

            SizedBox(height: 20),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ComprasListScreen()),
              );
            },
            child: const Text("Ver Compras"),
            )
          ],
        ),
      ),
    );
  }
}