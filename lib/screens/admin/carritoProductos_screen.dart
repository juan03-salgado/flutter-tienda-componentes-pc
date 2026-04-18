import 'package:flutter/material.dart';
import 'package:tienda_pc/models/carritoProducto.dart';
import 'package:tienda_pc/services/carritoProductos.service.dart';
import 'package:tienda_pc/services/compras.service.dart';
import 'package:tienda_pc/widgets/carrito_producto_card.dart';

class CarritoproductosScreen extends StatefulWidget {
  final int idCarrito;

  const CarritoproductosScreen({super.key, required this.idCarrito});

  @override
  State<CarritoproductosScreen> createState() => _CarritoproductosScreenState();
}

class _CarritoproductosScreenState extends State<CarritoproductosScreen> {

  final CarritoProductosService carritoProductosService = CarritoProductosService();
  final ComprasService comprasService = ComprasService();
  late Future<List <CarritoProducto>> productos;

  @override 
  void initState() {
    super.initState();
    productos = carritoProductosService.getCarritoProductos();
  }

  Future<void> recargar() async {
    setState(() {
      productos = carritoProductosService.getCarritoProductos();
    });
  }

  Future<void> realizarCompra() async {
    final lista = await productos;
    final productosCarrito = lista.where((p) => p.idCarrito == widget.idCarrito).toList();

    if(productosCarrito.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("El carrito esta vacio")));
      return;
    }
    
    final confirmarCompra = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(title: const Text("Confirmar compra"), content: const Text("¿Desea realizar la compra?"),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Comprar"))
        ],
      ),
    );

    if(confirmarCompra != true) return;
    try {
      await comprasService.realizarCompra(widget.idCarrito);
    
      if(!mounted) return;
      recargar();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Compra realizada con exito")));

    } catch(error){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error $error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Productos del carrito #${widget.idCarrito}"),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(onPressed: realizarCompra, style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          icon: Icon(Icons.shopping_bag_rounded),
          label: const Text("Comprar", style: TextStyle(fontSize: 20),),
          )
        )
      ),
      body: FutureBuilder<List <CarritoProducto>>( 
        future: productos,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){
            return const Center(child: Text("Error al cargar los productos del carrito"));
          }
          if(!snapshot.hasData || snapshot.data!.isEmpty){
            return const Center(child: Text("No hay productos en el carrito"));
          }

          final productosCarrito =  snapshot.data!.where((p) => p.idCarrito == widget.idCarrito).toList();
 
          return ListView.builder(itemCount: productosCarrito.length, itemBuilder: (context, index) {
            final carritoProductos = productosCarrito[index];

            return CarritoProductoCard(
              carritoProducto: carritoProductos,

              restar: () async {
                if(carritoProductos.cantidad > 1){
                  final productoActualizado = CarritoProducto(
                    id: carritoProductos.id,
                    idCarrito: carritoProductos.idCarrito,
                    idProducto: carritoProductos.idProducto,
                    cantidad: carritoProductos.cantidad - 1,
                    precioTotal: carritoProductos.precioTotal,
                    producto: carritoProductos.producto
                  );
                  await carritoProductosService.actualizarProductoCarrito(productoActualizado);
                  recargar();
                }
              },

              sumar: () async {
                final productoActualizado = CarritoProducto(
                  id: carritoProductos.id,
                  idCarrito: carritoProductos.idCarrito,
                  idProducto: carritoProductos.idProducto,
                  cantidad: carritoProductos.cantidad + 1,
                  precioTotal: carritoProductos.precioTotal,
                  producto: carritoProductos.producto
                );
                await carritoProductosService.actualizarProductoCarrito(productoActualizado);
                recargar();
              },

              eliminar: () async {
                final confirmar = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(title: const Text("Confirmar"), content: const Text("¿Desea eliminar este producto del carrito?"),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Eliminar"))
                  ],
                ));
                if(confirmar == true){
                  await carritoProductosService.eliminarProductoCarrito(carritoProductos.id!);
                  recargar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Producto eliminado del carrito")));
                }
              },
            );
          });
        }),
    );
  }
}