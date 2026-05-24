import 'package:flutter/material.dart';
import 'package:tienda_pc/models/productos.dart';
import 'package:tienda_pc/features/productos/screens/detalle_productos_screen.dart';
import 'package:tienda_pc/features/productos/screens/productos_formulario_screen.dart';
import 'package:tienda_pc/models/usuarios.dart';
import 'package:tienda_pc/services/producto.service.dart';
import 'package:tienda_pc/features/productos/widgets/productos_card.dart';

class ProductosScreen extends StatefulWidget {
  final int rol;
  final bool vista;
  final Usuario usuario;

  const ProductosScreen({super.key, required this.rol, required this.vista, required this.usuario});

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
      if(widget.vista){
        productos = productosService.getProductos();
      } else {
        productos = productosService.getProductoVendedor(widget.usuario.id!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Productos"),
      ),
      floatingActionButton: (!widget.vista) && (widget.rol == 1 || widget.rol == 2) ? FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final resultado = await Navigator.push(context, MaterialPageRoute(builder: (context) => ProductosFormularioScreen(usuario: widget.usuario)));
          
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => DetalleProductosScreen(producto: producto, usuario: widget.usuario)));
            },

            editar: (widget.rol == 1 || widget.rol == 2) ? () async {
              final resultado = await Navigator.push(context, MaterialPageRoute(builder: (context) => ProductosFormularioScreen(producto: producto, usuario: widget.usuario)));
              if(resultado == true){
                recargar();
              }
            }
            : null,

            eliminar: (widget.rol == 1 || widget.rol == 2) ? () async {
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
            }
            : null
          );
      });
      }),
    );
  }
}