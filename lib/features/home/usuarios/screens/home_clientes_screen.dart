import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tienda_pc/features/carrito/screens/carritoProductos_screen.dart';
import 'package:tienda_pc/features/home/usuarios/screens/compras_cliente_screen.dart';
import 'package:tienda_pc/features/home/usuarios/screens/cuenta_cliente_screen.dart';
import 'package:tienda_pc/features/home/usuarios/screens/notificaciones_screen.dart';
import 'package:tienda_pc/features/home/usuarios/widgets/home_cliente_card.dart';
import 'package:tienda_pc/features/home/usuarios/widgets/notificaciones_card.dart';
import 'package:tienda_pc/features/home/usuarios/widgets/promocion_card.dart';
import 'package:tienda_pc/features/home/vendedor/screens/ventasVendedor_screen.dart';
import 'package:tienda_pc/features/soporteTecnico/screens/soporteTecnico_screen.dart';
import 'package:tienda_pc/models/cliente.dart';
import 'package:tienda_pc/models/productos.dart';
import 'package:tienda_pc/models/usuarios.dart';
import 'package:tienda_pc/services/producto.service.dart';

class HomeClientesScreen extends StatefulWidget {
  final Usuario usuario;

  const HomeClientesScreen({super.key, required this.usuario});

  @override
  State<HomeClientesScreen> createState() => _HomeClientesScreenState();
}

class _HomeClientesScreenState extends State<HomeClientesScreen> {

  final List<Map<String, dynamic>> categorias = [
  {'id': 0, 'nombre': 'Todos'},
  {'id': 1, 'nombre': 'Laptops'},
  {'id': 2, 'nombre': 'Tarjetas gráficas'},
  {'id': 3, 'nombre': 'Procesadores'},
  {'id': 4, 'nombre': 'Memorias RAM'},
  {'id': 5, 'nombre': 'Almacenamiento'},
  {'id': 6, 'nombre': 'Periféricos'},
];

  final ProductoService productoService = ProductoService();
  List<Producto> productos = [];
  List<Producto> productosFiltrados = [];

  final TextEditingController buscador = TextEditingController();
  final PageController pageController = PageController();

  Cliente? cliente;
  bool loading = true;
  String categoriaSeleccionada = "Todos";

  @override
  void initState() {
    super.initState();
    cargarProductos();
  }

  Future<void> cargarProductos() async {
    try {
      final listaProductos = await productoService.getProductos();

      setState(() {
        productos = listaProductos;
        productosFiltrados = listaProductos;
      });

    } catch(error) {
      print("Error al cargar los productos $error");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void filtrar(String texto) async {
    final resultado = productos.where((p) {
      return p.nombre.toLowerCase().contains(texto.toLowerCase());
    }).toList();

    setState(() {
      productosFiltrados = resultado;
    });
  }

  void filtrarCategoria(String categoria) async {
    setState(() {
      categoriaSeleccionada = categoria;

      if(categoria == "Todos"){
        productosFiltrados = productos;
      } else {
        productosFiltrados = productos.where((p) {
          return p.categoriaNombre == categoria;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if(widget.usuario.idCarrito == null){
      return const Scaffold(body: Center(child: Text("No tienes carrito asignado"),));
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
            Color.fromARGB(255, 91, 93, 236),
            Color.fromARGB(255, 189, 111, 63),
            ]
          ).createShader(bounds),
          child: const Text("NovaTech", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CarritoproductosScreen(idCarrito: widget.usuario.idCarrito!)));
            }, 
            icon: const Icon(Icons.shopping_bag_outlined)
          ),

          NotificacionesCard(
            usuario: widget.usuario, 
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificacionesScreen(usuario: widget.usuario)));
              setState(() {});
            }
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFFF8F9FA),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 55, left: 20, right: 20, bottom: 25),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 91, 93, 236),
                    Color.fromARGB(255, 189, 111, 63), 
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
                )
              ),
              child: Row(
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(55),
                    ),
                    child: const Icon(Icons.person, size: 40, color: Color(0xFF6366F1)),
                  ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Bienvenido", style: TextStyle(color: Colors.white70, fontSize: 14)),
                          Text(widget.usuario.nombre, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                    )
                  )
                ],
              ),
            ),
            const SizedBox(height: 14),

            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined, color:Color(0xFF6366F1)),
              title: Text("Mi carrito"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CarritoproductosScreen(idCarrito: widget.usuario.idCarrito!)));
              },
            ),
              
            const SizedBox(height: 6),

            ListTile(
              leading: const Icon(Icons.receipt_long, color:Color(0xFF6366F1)),
              title: Text("Mis compras"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ComprasClienteScreen(usuario: widget.usuario, idCarrito: widget.usuario.idCarrito!)));
              },
            ),
            
            if(widget.usuario.rol == 2)
            ListTile(
              leading: const Icon(Icons.sell_outlined, color:Color(0xFF6366F1)),
              title: Text("Mis Ventas"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => VentasvendedorScreen(usuario: widget.usuario)));
              },
            ),

            const SizedBox(height: 6),

            ListTile(
              leading: const Icon(Icons.person_outlined, color: Color(0xFF6366F1)),
              title: Text("Cuenta"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CuentaClienteScreen(usuario: widget.usuario)));
              },
            ),

            const SizedBox(height: 6),

            ListTile(
              leading: const Icon(Icons.build_outlined, color:Color(0xFF6366F1)),
              title: Text("Soporte Tecnico"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SoportetecnicoScreen(usuario: widget.usuario)));
              },
            ),
            
            const Divider(height: 40, color: Colors.grey),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Cerrar Sesión"),
              onTap: () {
                Navigator.pushReplacementNamed(context, "/login");
              },
            )
          ],
        ),
      ),
      body: loading ? const Center(child: CircularProgressIndicator())
      : SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(12),
                child: TextField(
                  controller: buscador,
                  onChanged: filtrar,
                  decoration: InputDecoration(
                    hintText: "Buscar productos...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 45,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ChoiceChip(
                      label: Text("Todos", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: categoriaSeleccionada == "Todos" ? Colors.white : Colors.blueGrey)), 
                      selected: categoriaSeleccionada == "Todos",
                      onSelected: (context) => filtrarCategoria("Todos"),
                      selectedColor: const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    
                    const SizedBox(width: 6),
              
                    ChoiceChip(
                      label: Text("RAM", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: categoriaSeleccionada == "Memorias RAM" ? Colors.white : Colors.blueGrey)), 
                      selected: categoriaSeleccionada == "Memorias RAM",
                      onSelected: (context) => filtrarCategoria("Memorias RAM"),
                      selectedColor: const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
              
                    const SizedBox(width: 6),
              
                    ChoiceChip(
                      label: Text("PCs", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: categoriaSeleccionada == "Laptops" ? Colors.white : Colors.blueGrey)), 
                      selected: categoriaSeleccionada == "Laptops",
                      onSelected: (context) => filtrarCategoria("Laptops"),
                      selectedColor: const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
        
                    const SizedBox(width: 6),
              
                    ChoiceChip(
                      label: Text("Gráficas", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: categoriaSeleccionada == "Tarjetas gráficas" ? Colors.white : Colors.blueGrey)), 
                      selected: categoriaSeleccionada == "Tarjetas gráficas",
                      onSelected: (context) => filtrarCategoria("Tarjetas gráficas"),
                      selectedColor: const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
        
                    const SizedBox(width: 6),
              
                    ChoiceChip(
                      label: Text("Accesorios", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: categoriaSeleccionada == "Perifericos" ? Colors.white : Colors.blueGrey)), 
                      selected: categoriaSeleccionada == "Perifericos",
                      onSelected: (context) => filtrarCategoria("Perifericos"),
                      selectedColor: const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ],
                ),
              ),
            ), 
            
            SizedBox(
              height: 160,
              child: PageView(
                controller: pageController,
                physics: const PageScrollPhysics(),
                children: const [
                  PromocionCard(descripcion: "Ofertas de la semana", imagenUrl: "assets/img/promocion.jpg"),
                  PromocionCard(descripcion: "Componentes Gaming", imagenUrl: "assets/img/componentes.jpg"),
                  PromocionCard(descripcion: "Destacados de la semana", imagenUrl: "assets/img/destacados.jpg")
                ],
              ),
            ),
            
            SmoothPageIndicator(
              controller: pageController, 
              count: 3,
              effect: const ExpandingDotsEffect(
                dotHeight: 4,
                dotWidth: 10,
                activeDotColor: Colors.blue,
                dotColor: Colors.blueGrey
              ),
            ),

            const SizedBox(height: 10),
        
          productosFiltrados.isEmpty ? const Center(child: Text("No hay productos"))
          : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(15),
              itemCount: productosFiltrados.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 12,
              childAspectRatio: MediaQuery.of(context).size.width <= 360 ? 0.60 : 0.74,
            ),
              itemBuilder: (context, index) {
              final producto = productosFiltrados[index];
                      
              return HomeClienteCard(
                producto: producto,
                usuario: widget.usuario,
              );
            },
          ),
        ])
      ),
    );
  }
}