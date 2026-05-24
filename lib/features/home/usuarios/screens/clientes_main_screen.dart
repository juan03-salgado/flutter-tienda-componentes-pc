import 'package:flutter/material.dart';
import 'package:tienda_pc/features/carrito/screens/carritoProductos_screen.dart';
import 'package:tienda_pc/features/home/usuarios/screens/compras_cliente_screen.dart';
import 'package:tienda_pc/features/home/usuarios/screens/cuenta_cliente_screen.dart';
import 'package:tienda_pc/features/home/usuarios/screens/home_clientes_screen.dart';
import 'package:tienda_pc/models/usuarios.dart';

class ClientesMainScreen extends StatefulWidget {
  const ClientesMainScreen({super.key});

  @override
  State<ClientesMainScreen> createState() => _ClientesMainScreenState();
}

class _ClientesMainScreenState extends State<ClientesMainScreen> {

  int index = 0;
  Usuario? usuario;
  int? idCarrito;
  bool cargado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if(!cargado){
      final datos = ModalRoute.of(context)!.settings.arguments;
       
       if(datos != null && datos is Usuario){
        usuario = datos;
        idCarrito = usuario!.idCarrito;
      }
        cargado = true;
      }
    }

  void actualizarUsuario(Usuario nuevoUsuario){
    setState(() {
      usuario = nuevoUsuario;
    });
  }

  @override
  Widget build(BuildContext context) {

    if(usuario == null || idCarrito == null){
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final pantallas = [
      HomeClientesScreen(usuario: usuario!),
      CarritoproductosScreen(idCarrito: idCarrito!),
      ComprasClienteScreen(idCarrito: idCarrito!, usuario: usuario!),
      CuentaClienteScreen(usuario: usuario!),
    ];
    
    return Scaffold(
      body: pantallas[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) async {
          if(value == 3){
            final resultado = await Navigator.push(context, MaterialPageRoute(builder: (context) => CuentaClienteScreen(usuario: usuario!)));

            if(resultado != null && resultado is Usuario){
              actualizarUsuario(resultado);
            }
          } else {
            setState(() {
              index = value;
            });
          }
        },
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF5B5DEC),
        unselectedItemColor: Colors.blueGrey,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store_mall_directory_outlined), label: "Tienda"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_checkout), label: "Carrito"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Compras"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Cuenta"),
        ],
        ),
    );
  }
}
