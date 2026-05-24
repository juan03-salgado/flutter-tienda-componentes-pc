import 'package:flutter/material.dart';
import 'package:tienda_pc/features/productos/widgets/detalleProductos_card.dart';
import 'package:tienda_pc/features/productos/widgets/productoRelacionado_card.dart';
import 'package:tienda_pc/models/carritoProducto.dart';
import 'package:tienda_pc/models/productos.dart';
import 'package:tienda_pc/models/usuarios.dart';
import 'package:tienda_pc/services/carritoProductos.service.dart';
import 'package:tienda_pc/services/producto.service.dart';

class DetalleProductosScreen extends StatefulWidget {
  final Producto producto;
  final Usuario usuario;

  const DetalleProductosScreen({super.key, required this.producto, required this.usuario});

  @override
  State<DetalleProductosScreen> createState() => _DetalleProductosScreenState();
}

class _DetalleProductosScreenState extends State<DetalleProductosScreen> {

  final ProductoService productoService = ProductoService();
  late Future<List<Producto>> productosRelacionados;
  late Future<List <Producto>> otrosProductos;

  @override
  void initState() {
    super.initState();
    productosRelacionados = productoService.getProductoVendedor(widget.producto.id_vendedor!);
    otrosProductos = productoService.getProductos();
  }

  Future<void> agregarCarrito() async {
    try {
      final CarritoProductosService carritoProductosService = CarritoProductosService();
      final agregarProducto = CarritoProducto(
        id: null,
        cantidad: 1, 
        idCarrito: widget.usuario.idCarrito!, 
        idProducto: widget.producto.id!,
        producto: widget.producto
      ); 

      await carritoProductosService.agregarProductoCarrito(agregarProducto);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Producto agregado al carrito")));

    } catch(error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error al agregar al carrito")));
    }
  }

  @override
  Widget build(BuildContext context) {

    final producto = widget.producto;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(producto.nombre),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 320,
              color: Colors.white,
              child: producto.imagenUrl != null ? Image.network(producto.imagenUrl!, fit: BoxFit.contain) : const Icon(Icons.image, size: 100)
            ),

            const SizedBox(height: 10),
            DetalleproductosCard(
              producto: producto, 
              agregarCarrito: () async {
                try {
                  final CarritoProductosService carritoProductosService = CarritoProductosService();
                  final agregarProducto = CarritoProducto(
                    id: null,
                    cantidad: 1, 
                    idCarrito: widget.usuario.idCarrito!, 
                    idProducto: producto.id!,
                    producto: producto
                  );

                  await carritoProductosService.agregarProductoCarrito(agregarProducto);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Producto agregado al carrito")));

                } catch(error) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error al agregar al carrito")));
                }
              }
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Más productos de esta tienda", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 280,
                    child: FutureBuilder<List<Producto>>(
                      future: productosRelacionados,
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        if(snapshot.hasError){
                          return const Center(child: Text("Error al cargar los productos"));
                        }

                        final relacionados = snapshot.data!.where((p) => p.id != producto.id).toList();
                        
                        if(relacionados.isEmpty){
                          return const Center(child: Text("No hay mas productos"));
                        }

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: relacionados.length,
                          itemBuilder: (context, index) {
                            final productoRelacionado = relacionados[index];

                            return ProductoRelacionadoCard(
                              producto: productoRelacionado, 
                              usuario: widget.usuario
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Tambien te pueden interesar", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 280,
                    child: FutureBuilder<List<Producto>>(
                      future: otrosProductos,
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        if(snapshot.hasError){
                          return const Center(child: Text("Error al cargar los productos"));
                        }

                        final productos = snapshot.data!.where((p) => p.id != producto.id && p.id_vendedor != producto.id).take(10).toList();

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: productos.length,
                          itemBuilder: (context, index) {
                            final productoRelacionado = productos[index];

                            return ProductoRelacionadoCard(
                              producto: productoRelacionado, 
                              usuario: widget.usuario
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
