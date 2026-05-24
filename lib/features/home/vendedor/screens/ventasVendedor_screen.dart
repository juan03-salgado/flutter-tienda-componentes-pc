import 'package:flutter/material.dart';
import 'package:tienda_pc/features/home/vendedor/widgets/ventasVendedor_card.dart';
import 'package:tienda_pc/models/compras.dart';
import 'package:tienda_pc/models/usuarios.dart';
import 'package:tienda_pc/services/compras.service.dart';

class VentasvendedorScreen extends StatefulWidget {
  final Usuario usuario;

  const VentasvendedorScreen({super.key, required this.usuario});

  @override
  State<VentasvendedorScreen> createState() => _VentasvendedorScreenState();
}

class _VentasvendedorScreenState extends State<VentasvendedorScreen> {

  final ComprasService comprasService = ComprasService();
  late Future<List<Compras>> ventas;

  Future<List<Compras>> cargarVentas() async {
    return await comprasService.getVentasVendedor(widget.usuario.id!);
  }

  @override
  void initState() {
    super.initState();
    ventas = cargarVentas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventas'),
      ),
      body: FutureBuilder<List<Compras>>(
        future: ventas,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){
            return const Center(child: Text('Error al cargar las ventas'));
          }
          if(!snapshot.hasData || snapshot.data!.isEmpty){
            return const Center(child: Text('No hay ventas'));
          }

          final lista = snapshot.data!;

          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final compra = lista[index];
              return VentasvendedorCard(
                compras: compra, 
                usuario: widget.usuario, 
                titulo: "Venta",
                actualizar: () {
                  setState(() {
                    ventas = cargarVentas();
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}