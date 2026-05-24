import 'package:flutter/material.dart';
import 'package:tienda_pc/models/productos.dart';
import 'package:tienda_pc/models/serviciosTecnicos.dart';
import 'package:tienda_pc/models/usuarios.dart';
import 'package:tienda_pc/services/serviciosTecnicos.service.dart';

class CrearserviciosScreen extends StatefulWidget {
  final Usuario usuario;
  final Producto producto;

  const CrearserviciosScreen({super.key, required this.usuario, required this.producto});

  @override
  State<CrearserviciosScreen> createState() => _CrearserviciosScreenState();
}

class _CrearserviciosScreenState extends State<CrearserviciosScreen> {

  final tipoController = TextEditingController();
  final descripcionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final servicioService = ServiciostecnicosService();
  bool loading = false;

   final List<Map<String, dynamic>> tipoServicio = [
    {'id': 1, 'nombre': 'Solicitar reembolso'},
    {'id': 2, 'nombre': 'Devolución'},
    {'id': 3, 'nombre': 'Diagnostico'},
    {'id': 4, 'nombre': 'Otro'},
  ];

    Map<String, dynamic>? tipoSeleccionado;

  Future<void> crearServicio() async {
    if(!formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final tipoFinal = tipoSeleccionado?['nombre'] == 'Otro' ? tipoController.text.trim() : tipoSeleccionado?['nombre'];

    final servicio = Serviciostecnicos(
      tipoServicio: tipoFinal, 
      descripcion: descripcionController.text.trim(), 
      fechaSolicitud: "", 
      estado: "PENDIENTE", 
      usuario: widget.usuario,
      producto: widget.producto
    );

    try {
      await servicioService.crearServicioTecnico(servicio);

      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Servicio solicitado correctamente")));

      Navigator.pop(context, true);

    } catch(error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error $error")));
    }

    if(mounted){
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Atención al cliente"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                DropdownButtonFormField<Map<String, dynamic>>(
                  value: tipoSeleccionado,
                  decoration: const InputDecoration(
                    labelText: "Tipo servicio",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.build)
                  ),
                  items: tipoServicio.map((tipo) {
                    return DropdownMenuItem(
                      value: tipo,
                      child: Text(tipo['nombre']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      tipoSeleccionado = value;
                    });
                  },
                  validator: (value) => value == null ? "Seleccione un tipo" : null,
                ),
        
                const SizedBox(height: 15),
        
                if(tipoSeleccionado?['nombre'] == 'Otro')
                Column(
                  children: [
                    TextFormField(
                      controller: tipoController,
                      decoration: InputDecoration(labelText: "Especifique el tipo", border: OutlineInputBorder()),
                      validator: (value) {
                        if(tipoSeleccionado?['nombre'] == 'Otro' && (value == null || value.isEmpty)){
                          return "Debe especificar el tipo de servicio";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15)
                  ],
                ),
        
                TextFormField(
                  controller: descripcionController,
                  maxLines: 4,
                  decoration: const InputDecoration(border: OutlineInputBorder(), prefixIcon: Icon(Icons.description_rounded)),
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
                      onPressed: loading ? null : crearServicio, 
                      icon: const Icon(Icons.send),
                      label: Text(loading ? "Enviando..." : "Solicitar servicio")
                    ),
                  )
              ],
            )
          ),
        ),
      ),
    );
  }
}