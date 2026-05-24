import 'package:flutter/material.dart';
import 'package:tienda_pc/models/compras.dart';
import 'package:tienda_pc/features/compras/screens/detalleCompra_screen.dart';
import 'package:tienda_pc/services/compras.service.dart';
import 'package:tienda_pc/features/compras/widgets/compras_card.dart';

class ComprasListScreen extends StatefulWidget {
  const ComprasListScreen({super.key});

  @override
  State<ComprasListScreen> createState() => _ComprasListScreenState();
}

class _ComprasListScreenState extends State<ComprasListScreen> {
  final ComprasService comprasService = ComprasService();
  List<Compras> compras = [];
  
  String filtroEstado = "TODOS";

  @override
  void initState() {
    super.initState(); 
    cargarCompras();
  }

  Future<void> cargarCompras() async {
    try {
      final comprasCargadas = await comprasService.getCompras();
      setState(() {
        compras = comprasCargadas;
      });

    } catch(error) {
      print("Error $error");
    }
  }

  Future<void> eliminarCompra(int id) async {
    await comprasService.eliminarCompra(id);
    cargarCompras();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Compra eliminada")));
  }

  Future<void> cambiarEstado(int id, String estado) async {
    await comprasService.actualizarEstado(id, estado);
    cargarCompras();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Estado actualizado")));
  }

  @override
  Widget build(BuildContext context) {
    final comprasFiltradas = filtroEstado == "TODOS" ? compras : compras.where((c) => c.estado == filtroEstado).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Compras"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: DropdownButton<String>(
              value: filtroEstado,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: "TODOS", child: Text("TODOS")),
                DropdownMenuItem(value: "PENDIENTE", child: Text("PENDIENTE")),
                DropdownMenuItem(value: "COMPLETADA", child: Text("COMPLETADA")),
                DropdownMenuItem(value: "CANCELADA", child: Text("CANCELADA")),
              ],
              onChanged:(value) {
                setState(() {
                  filtroEstado = value!;
                });
              },
            ),
          ),
          Expanded(
            child: compras.isEmpty ? const Center(child: CircularProgressIndicator()) : comprasFiltradas.isEmpty ? const Center(child: Text("No hay compras"))
            : ListView.builder(
              itemCount: comprasFiltradas.length, 
              itemBuilder: (context, index){
                final compra = comprasFiltradas[index];

                return ComprasCard(
                  compras: compra,
                  verDetalle: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetallecompraScreen(compra: compra)));
                  },

                  eliminar: () async {
                    final confirmar = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(title: const Text("Confirmar"), content: const Text("¿Desea eliminar la compra?"),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Confirmar")),
                      ],
                      ),
                    );
                    if(confirmar == true){
                      eliminarCompra(compra.idCompra);
                    }
                  },
                  cambiarEstado: (estado) {
                    cambiarEstado(compra.idCompra, estado);
                  },
                );
            })
          )
        ],
      ),
    );
  }
}