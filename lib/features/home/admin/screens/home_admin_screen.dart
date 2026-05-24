import 'package:flutter/material.dart';
import 'package:tienda_pc/features/home/admin/widgets/home_admin_card.dart';
import 'package:tienda_pc/features/home/admin/widgets/resumen_card.dart';
import 'package:tienda_pc/models/usuarios.dart';
import 'package:tienda_pc/services/compras.service.dart';
import 'package:tienda_pc/services/producto.service.dart';
import 'package:tienda_pc/services/usuario.service.dart';

class HomeAdminScreen extends StatefulWidget {
  const HomeAdminScreen({super.key});

  @override
  State<HomeAdminScreen> createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen> {

  final UsuarioService usuarioService = UsuarioService();
  final ProductoService productoService = ProductoService();
  final ComprasService comprasService = ComprasService();

  int totalUsuarios = 0;
  int totalProductos = 0;
  int totalCompras = 0;
  bool loading = true;

  Usuario? usuario;
  bool cargado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!cargado){
      final datos = ModalRoute.of(context)!.settings.arguments;
      
      if(datos != null && datos is Usuario){
        usuario = datos;
      }
      cargarResumen();
      cargado = true;
    }
  }

  Future<void> cargarResumen() async {
    try {
      final usuarios = await usuarioService.getUsuarios();
      final productos = await productoService.getProductos();
      final compras = await comprasService.getCompras();

      setState(() {
        totalUsuarios = usuarios.length;
        totalProductos = productos.length;
        totalCompras = compras.length;
      });

    } catch(error) {
      print("Error al cargar el resumen de datos $error");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(usuario?.nombre ?? "Admin"), 
              accountEmail: Text(usuario?.email ?? "admin@email.com"),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person, size: 40, fontWeight: FontWeight.bold),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.people_alt_outlined),
              title: const Text("Usuarios"),
              onTap: () => Navigator.pushNamed(context, '/usuarios'),
            ),

            ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: const Text("Productos"),
              onTap: () => Navigator.pushNamed(context, '/productos', arguments: usuario),
            ),

            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: const Text("Compras"),
              onTap: () => Navigator.pushNamed(context, '/compras'),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red,),
              title: const Text("Cerrar Sesión"),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              }
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Panel Admin", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: loading ? const Center(child: CircularProgressIndicator()) : 
        Column(
          children: [
            Row(
              children: [
                ResumenCard(
                  titulo: "Usuarios",
                  icono: Icons.people,
                  valor: totalUsuarios.toString(),
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                 ResumenCard(
                  titulo: "Productos",
                  icono: Icons.inventory,
                  valor: totalProductos.toString(),
                  color: Colors.green,
                ),
                const SizedBox(width: 8),
                 ResumenCard(
                  titulo: "Compras",
                  icono: Icons.shopping_cart,
                  valor: totalCompras.toString(),
                  color: Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  HomeAdminCard(
                    titulo: "Gestionar Usuarios",
                    icono: Icons.people_alt_outlined,
                    color: Colors.blue,
                    onTap: () async {
                      await Navigator.pushNamed(context, '/usuarios');
                      cargarResumen();
                    } 
                  ),
                  HomeAdminCard(
                    titulo: "Gestionar productos",
                    icono: Icons.inventory_2_outlined,
                    color: Colors.blue,
                    onTap: () async {
                      await Navigator.pushNamed(context, '/productos', arguments: usuario);
                      cargarResumen();
                    } 
                  ),
                  HomeAdminCard(
                    titulo: "Ver compras",
                    icono: Icons.shopping_cart_checkout,
                    color: Colors.blue,
                    onTap: () async {
                      await Navigator.pushNamed(context, '/compras');
                      cargarResumen();
                    } 
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
