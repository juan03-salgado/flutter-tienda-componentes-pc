import 'package:flutter/material.dart';

class ClientesForm extends StatelessWidget {
  final TextEditingController nombreController;
  final TextEditingController direccionController;
  final TextEditingController telefonoController;
  final VoidCallback guardar;

  const ClientesForm({
    super.key,
    required this.nombreController,
    required this.direccionController,
    required this.telefonoController,
    required this.guardar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Center(
        child: Column(
          children: const [
            Icon(Icons.person, size: 50),
            SizedBox(height: 5),
            Text("Perfil cliente", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
          const SizedBox(height: 20),
          
          TextField(
            controller: nombreController,
            decoration: const InputDecoration(labelText: "Nombre"),
          ),

          TextField(
            controller: direccionController,
            decoration: const InputDecoration(labelText: "Dirección"),
          ),

          TextField(
            controller: telefonoController,
            decoration: const InputDecoration(labelText: "Teléfono"),
          ),

          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: guardar,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 114, 116, 231),
                shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
                elevation: 2
              ),
              child: const Text("Guardar", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );    
  }
}