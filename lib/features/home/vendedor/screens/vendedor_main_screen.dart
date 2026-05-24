import 'package:flutter/material.dart';
import 'package:tienda_pc/features/home/usuarios/screens/cuenta_cliente_screen.dart';
import 'package:tienda_pc/features/home/usuarios/screens/home_clientes_screen.dart';
import 'package:tienda_pc/features/home/vendedor/screens/ventasVendedor_screen.dart';
import 'package:tienda_pc/features/soporteTecnico/incidencias/screens/incidencias_screen.dart';
import 'package:tienda_pc/features/productos/screens/productos_screen.dart';
import 'package:tienda_pc/models/usuarios.dart';

class VendedorMainScreen extends StatefulWidget {
  const VendedorMainScreen({super.key});

  @override
  State<VendedorMainScreen> createState() => _VendedorMainScreenState();
}

class _VendedorMainScreenState extends State<VendedorMainScreen> {

  int index = 0;
  Usuario? usuario;
  bool cargado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!cargado){
      final datos = ModalRoute.of(context)!.settings.arguments;
       
      if(datos != null && datos is Usuario){
        usuario = datos;
      }
        cargado = true;
      }
    }

  @override
  Widget build(BuildContext context) {

    if(usuario == null){
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final pantallas = [
      HomeClientesScreen(usuario: usuario!),
      ProductosScreen(rol: usuario!.rol, vista: false, usuario: usuario!),
      VentasvendedorScreen(usuario: usuario!),
      CuentaClienteScreen(usuario: usuario!),
      IncidenciasScreen(usuario: usuario!)
    ];

    return Scaffold(

      body: pantallas[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) async {
          if(value == 3){
            final resultado = await Navigator.push(context, MaterialPageRoute(builder: (context) => CuentaClienteScreen(usuario: usuario!)));

            if(resultado != null && resultado is Usuario){
              setState(() {
                usuario = resultado;
              });
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
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: "Mis productos"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Ventas"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Mi Cuenta"),
        ],
      ),
    );
  }
}