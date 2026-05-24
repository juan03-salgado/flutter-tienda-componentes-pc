import 'package:flutter/material.dart';
import 'package:tienda_pc/features/carrito/widgets/carrito_producto_card.dart';
import 'package:tienda_pc/models/carritoProducto.dart';
import 'package:tienda_pc/services/carritoProductos.service.dart';
import 'package:tienda_pc/services/compras.service.dart';

class CarritoproductosScreen extends StatefulWidget {
  final int idCarrito;

  const CarritoproductosScreen({super.key, required this.idCarrito});

  @override
  State<CarritoproductosScreen> createState() => _CarritoproductosScreenState();
}

class _CarritoproductosScreenState extends State<CarritoproductosScreen> {

  final CarritoProductosService carritoProductosService = CarritoProductosService();
  final ComprasService comprasService = ComprasService();
  List<CarritoProducto> productos = [];
  bool loading = true;

  @override 
  void initState() {
    super.initState();
    recargar();
  }

  Future<void> recargar() async {
    final lista = await carritoProductosService.getCarritoProductosUsuario(widget.idCarrito);
    if(!mounted) return;
    setState(() {
      productos = lista;
      loading = false;
    });
  }

  Future<void> realizarCompra() async {
    final lista = await productos;
    final productosCarrito = lista.where((p) => p.idCarrito == widget.idCarrito).toList();
    final totalGeneral = productosCarrito.fold<double>(0, (sum, item) => sum + (item.precioTotal!));

    if(lista.isEmpty){
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
        title: Text("Mi carrito"),
      ),
      body: loading ? const Center(child: CircularProgressIndicator()) 
      : productos.isEmpty ? const Center(child: Text("No hay productos en el carrito")) : Builder (
        builder: (context) {
          final productosCarrito = productos.where((p) => p.idCarrito == widget.idCarrito).toList();

          if(productosCarrito.isEmpty){
            return const Center(child: Text("Tu carrito esta vacio"));
          }

          final totalGeneral = productosCarrito.fold<double>(0, (sum, item) => sum + (item.precioTotal!));

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: productosCarrito.length,
                  itemBuilder: (context, index) {
                    final carritoProductos = productosCarrito[index];

                    return CarritoProductoCard(
                      carritoProducto: carritoProductos, 

                      restar: () async {
                        if(carritoProductos.cantidad > 1){
                          final productoActualizado = CarritoProducto(
                            id: carritoProductos.id,
                            cantidad: carritoProductos.cantidad - 1, 
                            idCarrito: carritoProductos.idCarrito, 
                            idProducto: carritoProductos.idProducto,
                            precioTotal: null,
                            producto: carritoProductos.producto
                          );

                          await carritoProductosService.actualizarProductoCarrito(productoActualizado);
                          recargar();
                        }
                      },

                      sumar: () async {
                        final productoActualizado = CarritoProducto(
                            id: carritoProductos.id,
                            cantidad: carritoProductos.cantidad + 1, 
                            idCarrito: carritoProductos.idCarrito, 
                            idProducto: carritoProductos.idProducto,
                            precioTotal: null,
                            producto: carritoProductos.producto
                          );

                          await carritoProductosService.actualizarProductoCarrito(productoActualizado);
                          recargar();
                      },

                      eliminar: () async {
                        final confirmar = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Confirmar"),
                            content: const Text("¿Desea eliminar este producto del carrito?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false), 
                                child: const Text("Cancelar")
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true), 
                                child: const Text("Eliminar")
                              ),
                            ],
                          ),
                        );
                        if(confirmar == true){
                          await carritoProductosService.eliminarProductoCarrito(carritoProductos.id!);
                          recargar();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Producto eliminado del carrito")));
                        }
                      },  
                    );  
                  }
                )
              ),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade300, width: 1),
                  )
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("\$${totalGeneral.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18))
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: realizarCompra, 
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text("Comprar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 21, 135, 228),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 3
                        )
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      )
    );
  }
}