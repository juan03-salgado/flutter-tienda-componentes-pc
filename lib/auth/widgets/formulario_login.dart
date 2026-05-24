import 'package:flutter/material.dart';

class FormularioLogin extends StatelessWidget{

  final GlobalKey<FormState> formKey;
  final TextEditingController nombreController;
  final TextEditingController contrasenaController;
  final VoidCallback registrarse;
  final VoidCallback login;
  final bool verContrasena;
  final bool loading;
  final VoidCallback mostrarContrasena;

  const FormularioLogin({
    super.key,
    required this.formKey,
    required this.nombreController,
    required this.contrasenaController,
    required this.login,
    required this.registrarse,
    this.verContrasena = false,
    required this.loading,
    required this.mostrarContrasena,
  });

  @override 
  Widget build(BuildContext context){
    return Form(
      key: formKey,
      child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 35),
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 69, 71, 224),
                    Color.fromARGB(255, 202, 120, 68),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight, 
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 91, 93, 236).withOpacity(0.4),
                    blurRadius: 18,
                    offset: const Offset(0, 8)
                  )
                ]
              ),
              child: const Icon(Icons.computer_rounded, color: Colors.white, size: 42),
            ),
          ),

          const SizedBox(height: 12),
          const Center(
            child: Text("Bienvenido", style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, letterSpacing: -1)),
          ),

          const SizedBox(height: 10),
          Center(
            child: Text("Inicia sesión para continuar", style: TextStyle(fontSize: 15, color: Colors.grey.shade600)),
          ),

          const SizedBox(height: 45),

          TextFormField(
            controller: nombreController, 
            validator: (value) => value!.isEmpty ? "Campo requerido" : null,
            decoration: InputDecoration(
              labelText: 'Nombre de usuario', 
              prefixIcon: const Icon(Icons.person_outline, color: Color.fromARGB(255, 91, 93, 236),
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18)
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18), 
              borderSide: BorderSide.none
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18), 
              borderSide: const BorderSide(color: Color.fromARGB(255, 91, 93, 236), width: 1.5))
          ),
        ),

          const SizedBox(height: 22),
          TextFormField(
            controller: contrasenaController,
            validator: (value) => value!.isEmpty ? "Campo requerido" : null,
            obscureText: !verContrasena,
            decoration: InputDecoration(
              labelText: 'Contraseña', 
              prefixIcon: const Icon(Icons.lock_outline, color: Color.fromARGB(255, 91, 93, 236),
            ), 
            filled: true,
            fillColor: Colors.grey.shade100,
            suffixIcon: IconButton(
              onPressed: mostrarContrasena, 
              icon: Icon(verContrasena ? Icons.visibility: Icons.visibility_off)
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18)
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18), 
              borderSide: BorderSide.none
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18), 
              borderSide: const BorderSide(color: Color.fromARGB(255, 91, 93, 236), width: 1.5))
          ),
        ),

          const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: loading ? null : login, 
                style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: const Color.fromARGB(255, 91, 93, 236),
                shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20))
              ),
              child: Ink(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: loading ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text("Iniciar Sesión", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)
                  ),
                )
              )
            ),
          ),
          const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("¿No tienes cuenta?", style: TextStyle(color: Colors.grey.shade700)),
                  TextButton(
                    onPressed: registrarse, 
                    child: const Text("Registrate", style: TextStyle(color: Color.fromARGB(255, 91, 93, 236), fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                  const SizedBox(height: 15)
              ],
            )
         )
      );
  }
}