import 'package:flutter/material.dart';
import 'package:tienda_pc/models/usuarios.dart';
import 'package:tienda_pc/services/usuario.service.dart';

class ConvertirvendedorScreen extends StatefulWidget {
  final Usuario usuario;

  const ConvertirvendedorScreen({super.key, required this.usuario});

  @override
  State<ConvertirvendedorScreen> createState() => _ConvertirvendedorScreenState();
}

class _ConvertirvendedorScreenState extends State<ConvertirvendedorScreen> {

  final UsuarioService usuarioService = UsuarioService();

  final telefonoController = TextEditingController();
  final direccionController = TextEditingController();
  final nombreTiendaController = TextEditingController();
  bool loading = false;

  Future<void> convertirVendedor() async {
    setState(() => loading = true);

    try {
      await usuarioService.convertirVendedor(
        widget.usuario.id!,
        telefonoController.text,
        direccionController.text,
        nombreTiendaController.text
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ahora eres vendedor")));
      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);

    } catch(error){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $error")));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Convertirse en vendedor"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.store, size: 70, color: Colors.blue),
            const SizedBox(height: 10),
            const Text("Empieza a vender", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            const Text("Completa los datos para convertirte en vendedor", textAlign: TextAlign.center),
            const SizedBox(height: 20),
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
           child: Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: Column(
              children: [
                TextField(
                  controller: telefonoController,
                  decoration: const InputDecoration(labelText: "Telefono", prefixIcon: Icon(Icons.phone), border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
          
                TextField(
                  controller: direccionController,
                  decoration: const InputDecoration(labelText: "Dirección", prefixIcon: Icon(Icons.location_on_outlined), border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: nombreTiendaController,
                  decoration: const InputDecoration(labelText: "Nombre de Tienda", prefixIcon: Icon(Icons.storefront), border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
          
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.store),
                    label: loading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text("Convertirme en vendedor"),
                    onPressed: loading ? null : convertirVendedor,
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
                  ),
                )
              ],
            ),
          ),
          )
        ],
      ),
    )
  );
  }
}