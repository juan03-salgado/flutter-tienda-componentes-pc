import 'package:flutter/material.dart';
import 'package:tienda_pc/features/home/usuarios/widgets/clientes_form.dart';
import 'package:tienda_pc/features/home/usuarios/widgets/usuarios_form.dart';
import 'package:tienda_pc/features/home/vendedor/screens/convertirVendedor_screen.dart';
import 'package:tienda_pc/models/cliente.dart';
import 'package:tienda_pc/models/usuarios.dart';
import 'package:tienda_pc/services/clientes.service.dart';
import 'package:tienda_pc/services/usuario.service.dart';

class CuentaClienteScreen extends StatefulWidget {
  final Usuario usuario;

  const CuentaClienteScreen({super.key, required this.usuario});

  @override
  State<CuentaClienteScreen> createState() => _CuentaClienteScreenState();
}

class _CuentaClienteScreenState extends State<CuentaClienteScreen> {

  final ClientesService clientesService = ClientesService();
  final UsuarioService usuarioService = UsuarioService();
  late Usuario usuarioActual;

  Cliente? cliente;
  bool loading = true;
  bool mostrarCliente = true;

  final nombreController = TextEditingController();
  final direccionController = TextEditingController();
  final telefonoController = TextEditingController();
  final emailController = TextEditingController();
  final contrasenaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    usuarioActual = widget.usuario;
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    try {
      final lista = await clientesService.getClientes();
      final encontrado = lista.firstWhere((c) => c.idUsuario == widget.usuario.id);

      setState(() {
        cliente = encontrado;

        nombreController.text = encontrado.nombre;
        direccionController.text = encontrado.direccion;
        telefonoController.text = encontrado.telefono;
        emailController.text = widget.usuario.email;
      });
    } catch(error){
      print("Error cargando datos: $error");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> guardarCliente() async {
    if(cliente == null) return;

    try {
        final clienteActualizado = Cliente(
          id: cliente!.id,
          nombre: nombreController.text,
          direccion: direccionController.text,
          telefono: telefonoController.text,
          idUsuario: widget.usuario.id!,
        );
      
      await clientesService.actualizarCliente(clienteActualizado);

      final usuarioActualizado = Usuario(
        id: widget.usuario.id,
        nombre: nombreController.text,
        email: widget.usuario.email,
        contrasena: widget.usuario.contrasena,
        rol: widget.usuario.rol,
        idCarrito: widget.usuario.idCarrito,
      ); 

      await usuarioService.actualizarUsuario(usuarioActualizado);

      final actualizado = await usuarioService.getUsuarioId(usuarioActualizado.id!);

      setState(() {
        usuarioActual = actualizado;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Datos actualizados")));
      Navigator.pop(context, usuarioActualizado);

    } catch(error){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error $error")));
    }
  }

  Future<void> guardarUsuario() async {
    try {
        final usuarioActualizado = Usuario(
          id: widget.usuario.id,
          nombre: nombreController.text,
          email: emailController.text,
          contrasena: contrasenaController.text,
          rol: widget.usuario.rol,
          idCarrito: widget.usuario.idCarrito
      );
      await usuarioService.actualizarUsuario(usuarioActualizado);

      final actualizado = await usuarioService.getUsuarioId(usuarioActualizado.id!);

      setState(() {
        usuarioActual = actualizado;
      });

      if(cliente != null){
        await clientesService.actualizarCliente(
          Cliente(
            id: cliente!.id,
            nombre: nombreController.text, 
            direccion: direccionController.text, 
            telefono: telefonoController.text, 
            idUsuario: widget.usuario.id!
          )
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cuenta actualizada")));
      Navigator.pop(context, usuarioActualizado);

    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $error")));   
    }
  }

  @override
  void dispose(){
    super.dispose();
    nombreController.dispose();
    direccionController.dispose();
    telefonoController.dispose();
    emailController.dispose();
    contrasenaController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(loading){
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi cuenta"),
        actions: [
          IconButton(
            icon: Icon(mostrarCliente ? Icons.person_pin : Icons.badge_outlined),
            onPressed: () {
              setState(() {
                mostrarCliente = !mostrarCliente;
              });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: mostrarCliente ? 
                  
                  ClientesForm(
                    nombreController: nombreController, 
                    direccionController: direccionController, 
                    telefonoController: telefonoController, 
                    guardar: guardarCliente
                    )
                    
                  : UsuariosForm(
                    nombreController: nombreController,
                    emailController: emailController, 
                    contrasenaController: contrasenaController, 
                    guardar: guardarUsuario
                  ),
                ),
            ),
            const SizedBox(height: 20),

            if(widget.usuario.rol == 3)
            Card(
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12)),
              child: Padding(
                padding: const EdgeInsetsGeometry.all(15),
                child: Column(
                  children: [
                    const Icon(Icons.store, size: 30, color: Colors.blue),
                    const SizedBox(height: 10),
                    const Text("¿Quieres vender en la plataforma?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    const Text("Conviertete en vendedor y empieza a publicar productos facilmente.", textAlign: TextAlign.center),
                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.store),
                        label: Text("Convertirme en vendedor"),
                        onPressed: () async {
                          final resultado = Navigator.push(context, MaterialPageRoute(builder: (context) => ConvertirvendedorScreen(usuario: widget.usuario)));
                          if(resultado == true){
                            Navigator.pushReplacementNamed(context, "/login");
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        )
      ),
    );
  }
  }