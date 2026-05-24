import 'package:flutter/material.dart';
import 'package:tienda_pc/features/soporteTecnico/incidencias/screens/incidencias_screen.dart';
import 'package:tienda_pc/features/soporteTecnico/serviciosTecnicos/screens/servicios_screen.dart';
import 'package:tienda_pc/models/usuarios.dart';

class SoportetecnicoScreen extends StatelessWidget {
  final Usuario usuario;

  const SoportetecnicoScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Soporte Técnico", style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            indicatorWeight: 3,
            tabs: [
              Tab(
                icon: Icon(Icons.report_problem_outlined),
                text: "Incidencias",
              ),
              Tab(
                icon: Icon(Icons.build_outlined),
                text: "Servicios",
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            IncidenciasScreen(usuario: usuario),
            ServiciosScreen(usuario: usuario)
          ]
        ),
      )
    );
  }
}