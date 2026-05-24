import 'package:flutter/material.dart';
import 'package:tienda_pc/features/home/usuarios/widgets/detalle_compra_cliente.dart';
import 'package:tienda_pc/models/compras.dart';
import 'package:tienda_pc/models/usuarios.dart';
import 'package:tienda_pc/services/compras.service.dart';

class ComprasClienteScreen extends StatefulWidget {
  final int idCarrito;
  final Usuario usuario;

  const ComprasClienteScreen({super.key, required this.idCarrito, required this.usuario});

  @override
  State<ComprasClienteScreen> createState() => _ComprasClienteScreenState();
}

class _ComprasClienteScreenState extends State<ComprasClienteScreen> {

  ComprasService comprasService = ComprasService();
  late Future <List<Compras>> compras;

  Future<List<Compras>> cargarComprasUsuario() async {
    return await comprasService.getCompraUsuario(widget.usuario.id!);
}

  @override
  void initState() {
    super.initState();
    compras = cargarComprasUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis compras"),
      ),
      body: FutureBuilder<List<Compras>>(
        future: compras,
        builder: (context, snapshot) {
          
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator()); 
          }

          if(!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No tienes compras"));
          }

          final lista = snapshot.data!;
          
          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final compra = lista[index];

              return ListTile(
                leading: const Icon(Icons.receipt_long),
                title: Text("Compra #${compra.idCompra}"),
                subtitle: Text("Estado: ${compra.estado}"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DetalleCompraCliente(compra: compra, usuario: widget.usuario)));
                },
              );
            },
          );
        },
      ),
    );
    }
  }
