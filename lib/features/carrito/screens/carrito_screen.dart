import 'package:flutter/material.dart';
import 'package:tienda_pc/features/carrito/screens/carritoProductos_screen.dart';
import 'package:tienda_pc/models/carrito.dart';
import 'package:tienda_pc/services/carrito.service.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {

  final CarritoService carritoService = CarritoService();
  late Future<List<Carrito>> carritos;

  @override
  void initState() {
    super.initState();
    carritos = carritoService.getCarrito();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carritos"),
      ),
      body: FutureBuilder<List<Carrito>>(
        future: carritos,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){
            return const Center(child: Text("Error al cargar los carritos"));
          }
          if(!snapshot.hasData || snapshot.data!.isEmpty){
            return const Center(child: Text("No hay carritos"));
          }

          final listaCarritos = snapshot.data!;

          return ListView.builder(itemCount: listaCarritos.length, itemBuilder: (context, index) {
            final carrito = listaCarritos[index];

            return Card(
              child: ListTile(
                leading: const Icon(Icons.shopping_cart_outlined),
                title: Text("Carrito #${carrito.id}"),
                subtitle: Text("Cliente ID: ${carrito.idCliente}"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CarritoproductosScreen(idCarrito: carrito.id!)));
                },
              ),
            );
          });
        }),
    );
  }
}