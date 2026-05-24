import 'package:flutter/material.dart';
import 'package:tienda_pc/models/serviciosTecnicos.dart';
import 'package:tienda_pc/models/usuarios.dart';
import 'package:tienda_pc/services/serviciosTecnicos.service.dart';
import 'package:tienda_pc/features/soporteTecnico/serviciosTecnicos/widgets/serviciosTecnicos_card.dart';

class ServiciosScreen extends StatefulWidget {
  final Usuario usuario;

  const ServiciosScreen({super.key, required this.usuario});

  @override
  _ServiciosScreenState createState() => _ServiciosScreenState();
}

class _ServiciosScreenState extends State<ServiciosScreen> {

  final ServiciostecnicosService serviciostecnicosService = ServiciostecnicosService();
  late Future<List<Serviciostecnicos>> servicios;
  
  @override
  void initState() {
    super.initState();
    cargarServicios();
  }

  void cargarServicios() {
    setState(() {
      if(widget.usuario.rol == 3){
        servicios = serviciostecnicosService.getServiciosCliente(widget.usuario.id!);
      } else if (widget.usuario.rol == 2){
        servicios = serviciostecnicosService.getServiciosVendedor(widget.usuario.id!);
      } else {
        servicios = serviciostecnicosService.getServiciosTecnicos();
      }
    });
  }

  Future<void> eliminarServicio(int id) async {
    await serviciostecnicosService.eliminarServicioTecnico(id);
    cargarServicios();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Servicio eliminado")));
  }

  Future<void> cambiarEstado(int id, String estado, String mensaje) async {
    await serviciostecnicosService.actualizarEstado(id, estado, mensaje);
    cargarServicios();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Estado del servicio actualizado")));
  }

  @override
  Widget build(BuildContext context) {
    final esCliente = widget.usuario.rol == 3;

    return Scaffold(
      body: FutureBuilder<List <Serviciostecnicos>>(
        future: servicios,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){
            return const Center(child: Text("Error al cargar los servicios"));
          }

          final listaServicios = snapshot.data ?? [];

          if(listaServicios.isEmpty){
            return const Center(child: Text("No hay servicios solicitados"));
          }

          return ListView.builder(
           itemCount: listaServicios.length,
           itemBuilder: (context, index) {
             final servicio = listaServicios[index];

             return ServiciostecnicosCard(
              servicio: servicio,
              esCliente: esCliente,
              eliminar: () => eliminarServicio(servicio.id!), 
              cambiarEstado: (estado, mensaje) => cambiarEstado(servicio.id!, estado, mensaje)
              );
           },
          );
        },
      )
    );
  }
}