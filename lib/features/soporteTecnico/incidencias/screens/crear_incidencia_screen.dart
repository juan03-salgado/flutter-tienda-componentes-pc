import 'package:flutter/material.dart';
import 'package:tienda_pc/models/incidencias.dart';
import 'package:tienda_pc/models/productos.dart';
import 'package:tienda_pc/models/usuarios.dart';
import 'package:tienda_pc/services/incidencias.service.dart';

class CrearIncidenciaScreen extends StatefulWidget {
  final Usuario usuario;
  final Producto producto;

  const CrearIncidenciaScreen({super.key, required this.usuario, required this.producto});

  @override
  State<CrearIncidenciaScreen> createState() => _CrearIncidenciaScreenState();
}

class _CrearIncidenciaScreenState extends State<CrearIncidenciaScreen> {

  final descripcionController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final incidenciasService = IncidenciasService();
  bool loading = false;

  Future<void> crearIncidencias() async {
    if(!formkey.currentState!.validate()) return;

    setState(() => loading = true);

    final incidencia = Incidencia(
      descripcion: descripcionController.text, 
      estado: "PENDIENTE", 
      usuario: widget.usuario, 
      producto: widget.producto
    );

    try {
      await incidenciasService.crearIncidencia(incidencia);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Incidencia creada correctamente"))
    );
      Navigator.pop(context, true);

    } catch(error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $error")));
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reportar incidencia"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formkey,
          child: Column(
            children: [
              Card(
                elevation: 3,
                child: ListTile(
                  leading: producto.imagenUrl != null ? Image.network(producto.imagenUrl!, width: 50) : const Icon(Icons.image),
                  title: Text(producto.nombre),
                  subtitle: Text("\$${producto.precioUnidad}"),
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: descripcionController,
                maxLines: 4,
                decoration: const InputDecoration(label: Text("Describa el problema"), border: OutlineInputBorder(), prefixIcon: Icon(Icons.report_problem_rounded)),
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return "Campo requerido";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: loading ? null : crearIncidencias,
                  icon: const Icon(Icons.send),
                  label: Text(loading ? "Enviando..." : "Reportar incidencia")
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}