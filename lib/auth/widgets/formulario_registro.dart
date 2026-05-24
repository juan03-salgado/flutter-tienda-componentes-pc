import 'package:flutter/material.dart';

class FormularioRegistro extends StatelessWidget {

  final GlobalKey<FormState> formkey;
  final TextEditingController nombreController;
  final TextEditingController emailController;
  final TextEditingController contrasenaController;
  final TextEditingController confirmarContrasenaController;
  final VoidCallback registrar;
  final bool verContrasena;
  final VoidCallback mostrarContrasena;
  final bool loading;

  const FormularioRegistro({
    super.key,
    required this.nombreController,
    required this.emailController,
    required this.contrasenaController,
    required this.confirmarContrasenaController,
    required this.formkey,
    required this.registrar,
    this.verContrasena = false,
    required this.mostrarContrasena,
    required this.loading
  });

  @override 
  Widget build(BuildContext context){
    return Form(
    key: formkey, 
    child: SingleChildScrollView(  
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 91, 93, 236),
                    Color.fromARGB(255, 189, 111, 63),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight, 
                 ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 91, 93, 236).withOpacity(0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 8)
                  )
                ]
              ),
              child: const Icon(Icons.computer_rounded, color: Colors.white, size: 42),
            ),
          ),

        const SizedBox(height: 10),

        const Center(
          child: Text("Crear cuenta", style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, letterSpacing: -1)),
        ),

        const SizedBox(height: 10),
        Center(
          child: Text("Registrate para comenzar", style: TextStyle(fontSize: 15, color: Colors.grey.shade600)),
        ),

        const SizedBox(height: 25),

        TextFormField(
          controller: nombreController,
          validator: (value) => value!.isEmpty ? "Campo requerido" : null,
          decoration: InputDecoration(
            label: Text("Nombre"), 
            prefixIcon: Icon(Icons.person_outline, 
            color: Color.fromARGB(255, 91, 93, 236),
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18), 
            borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18), 
            borderSide: const BorderSide(color: Color.fromARGB(255, 91, 93, 236), width: 1.5))
          ),
        ),

        SizedBox(height: 20),
    
        TextFormField(
          controller: emailController,
          validator: (value){
            if(value == null || value.isEmpty) return "Campo requerido";
            if(!value.contains("@")) return "Email invalido";
            return null;
          },
          decoration: InputDecoration(label: Text("Email"), prefixIcon: Icon(Icons.email_outlined, color: Color.fromARGB(255, 91, 93, 236)),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18), 
            borderSide: BorderSide.none
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18), 
            borderSide: const BorderSide(color: Color.fromARGB(255, 91, 93, 236), width: 1.5))
          ),
        ),

        SizedBox(height: 20),
    
        TextFormField(
          controller: contrasenaController,
          obscureText: !verContrasena,
          validator: (value) => value!.isEmpty ? "Campo requerido" : null,
          decoration: InputDecoration(
            label: Text("Contraseña"), 
            prefixIcon: Icon(Icons.lock_outline, color: Color.fromARGB(255, 91, 93, 236),),
          suffixIcon: IconButton(
            onPressed: mostrarContrasena, 
            icon: Icon(verContrasena ? Icons.visibility : Icons.visibility_off)
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18), 
            borderSide: BorderSide.none
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18), 
            borderSide: const BorderSide(color: Color.fromARGB(255, 91, 93, 236), width: 1.5))
          ),
        ),

        SizedBox(height: 20),
    
        TextFormField(
          controller: confirmarContrasenaController,
          obscureText: !verContrasena,
          validator: (value) {
            if(value == null || value.isEmpty) return "Campo requerido";
            if(value != contrasenaController.text) return "Las contraseñas no coinciden";
            return null;
          },
          decoration:InputDecoration(
            label: Text("Confirmar contraseña"),
            prefixIcon: Icon(Icons.lock_reset, color: Color.fromARGB(255, 91, 93, 236)),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
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
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: loading ? null : registrar, 
            style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 91, 93, 236), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
            child: loading ? const CircularProgressIndicator(color: Colors.white) : const Text("Registrarse", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold))
          ),
        ),
        const SizedBox(height: 20)
      ],
    ),
    ),
    );
  }
}