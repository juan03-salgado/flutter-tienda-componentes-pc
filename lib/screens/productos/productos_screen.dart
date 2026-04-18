import 'package:flutter/material.dart';
import 'package:tienda_pc/models/productos.dart';
import 'package:tienda_pc/screens/productos/detalle_productos_screen.dart';
import 'package:tienda_pc/screens/productos/productos_formulario_screen.dart';
import 'package:tienda_pc/services/producto.service.dart';
import 'package:tienda_pc/widgets/productos_card.dart';

class ProductosScreen extends StatefulWidget {
  final int rol;

  const ProductosScreen({super.key, required this.rol});

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {

  final ProductoService productosService = ProductoService();
  late Future<List<Producto>> productos;

  @override
  void initState() {
    super.initState();
    recargar();
  }

  void recargar() {
    setState(() {
      productos = productosService.getProductos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Productos"),
      ),
      floatingActionButton: (widget.rol == 1 || widget.rol == 2) ? FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final resultado = await Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductosFormularioScreen()));
          
          if(resultado == true){
            recargar();
          }
        },
      )
      :null,
      body: FutureBuilder<List<Producto>>(
        future: productos,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){
            return const Center(child: Text("Error al cargar los productos"));
          }
          final listaProductos = snapshot.data ?? [];

          if(listaProductos.isEmpty){
            return const Center(child: Text("No hay productos disponibles"));
          }

          return ListView.builder(itemCount: listaProductos.length, itemBuilder: (context, index){
          final producto = listaProductos[index];

          return ProductosCard(
            producto: producto,
            rol: widget.rol,
            onTap:() {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DetalleProductosScreen(producto: producto),));
            },

            editar: () async {
              final resultado = await Navigator.push(context, MaterialPageRoute(builder: (context) => ProductosFormularioScreen(producto: producto)));
              if(resultado == true){
                recargar();
              }
            },

            eliminar: () async {
              final confirmar = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(title: const Text("Confirmar"), content: const Text("¿Desea eliminar este producto?"),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
                  TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Eliminar")),
                ],
              ));
              if(confirmar == true){
                await productosService.eliminarProducto(producto.id!);
                recargar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Producto eliminado correctamente")));
              }
            },
          );
      });
      }),
    );
  }
}