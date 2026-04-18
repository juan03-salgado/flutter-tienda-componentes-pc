import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tienda_pc/models/productos.dart';
import 'package:tienda_pc/services/producto.service.dart';

class ProductosFormularioScreen extends StatefulWidget {
  final Producto? producto;

  const ProductosFormularioScreen({super.key, this.producto});

  @override
  State<ProductosFormularioScreen> createState() => _ProductosFormularioScreenState();
}

class _ProductosFormularioScreenState extends State<ProductosFormularioScreen> {

  final ProductoService productoService = ProductoService();
  final formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  final precioController = TextEditingController();
  final unidadesController = TextEditingController();
  
  final List<Map<String, dynamic>> categorias = [
    {'id': 1, 'nombre': 'Laptops'},
    {'id': 2, 'nombre': 'Tarjetas gráficas'},
    {'id': 3, 'nombre': 'Procesadores'},
    {'id': 4, 'nombre': 'Memorias RAM'},
    {'id': 5, 'nombre': 'Almacenamiento'},
    {'id': 6, 'nombre': 'Periféricos'},
  ];

  int? categoriaSeleccionada;
  File? imagenSeleccionada;

  @override
  void initState() {
    super.initState();

    if(widget.producto != null){
      nombreController.text = widget.producto!.nombre;
      descripcionController.text = widget.producto!.descripcion;
      precioController.text = widget.producto!.precioUnidad.toString();
      unidadesController.text = widget.producto!.unidades.toString();
      categoriaSeleccionada = widget.producto!.idCategoria;
    }
  }

  Future<void> seleccionarImagen() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile != null){
      setState(() {
        imagenSeleccionada = File(pickedFile.path);
      });
    }
  }

  Future<void> guardarProducto() async {
    if(!formKey.currentState!.validate()) return;

    final producto = Producto(
      id: widget.producto?.id,
      nombre: nombreController.text,
      descripcion: descripcionController.text,
      idCategoria: categoriaSeleccionada,
      categoriaNombre: "",
      precioUnidad: double.tryParse(precioController.text) ?? 0,
      unidades: int.tryParse(unidadesController.text) ?? 0,
  );

    try{
      if(widget.producto == null){
        await productoService.crearProducto(producto, imagenSeleccionada);
      } else {
        await productoService.actualizarProducto(producto, imagenSeleccionada);
      }

      Navigator.pop(context, true);

    } catch(error) {
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error al guardar el producto")));
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.producto == null ? "Crear producto" : "Editar producto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: "Nombre", border: OutlineInputBorder(), prefixIcon: Icon(Icons.computer)),
                  validator: (value) => value!.isEmpty ? "Campo requerido" : null,
                ),

                const SizedBox(height: 20),
                TextFormField(
                  controller: descripcionController,
                  decoration: const InputDecoration(labelText: "Descripción", border: OutlineInputBorder(), prefixIcon: Icon(Icons.description)),
                  validator: (value) => value!.isEmpty ? "Campo requerido" : null,
                ),

                const SizedBox(height: 20),
                DropdownButtonFormField<int>(
                  value: categoriaSeleccionada,
                  decoration: const InputDecoration(labelText: "Categoria", border: OutlineInputBorder(), prefixIcon: Icon(Icons.category),),
                  items: categorias.map((cat) {
                    return DropdownMenuItem<int>(value: cat['id'], child: Text(cat['nombre']),);
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      categoriaSeleccionada = value;
                    });
                  },
                  validator: (value) => value == null ? "Seleccione una categoria" : null,
                ),

                const SizedBox(height: 20),
                TextFormField(
                  controller: precioController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Precio", border: OutlineInputBorder(), prefixIcon: Icon(Icons.attach_money)),
                  validator: (value) => value!.isEmpty ? "Campo requerido" : null,
                ),

                const SizedBox(height: 20),
                TextFormField(
                  controller: unidadesController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Unidades", border: OutlineInputBorder(), prefixIcon: Icon(Icons.inventory)),
                  validator: (value) => value!.isEmpty ? "Campo requerido" : null,
                ),
                
                const SizedBox(height: 20),
                Column(
                  children: [
                    imagenSeleccionada != null ? Image.file(imagenSeleccionada!, height: 150) : 
                    (widget.producto?.imagenUrl != null ? Image.network(widget.producto!.imagenUrl!, height: 150) :
                    const Text("No hay imagen")),
                    
                    const SizedBox(height: 10),
                    ElevatedButton.icon(onPressed: seleccionarImagen, icon: const Icon(Icons.image), label: const Text("Seleccionar imagen")),
                  ],
                ),
                  const SizedBox(height: 20),
                  ElevatedButton(onPressed: guardarProducto, child: Text(widget.producto == null ? "Crear" : "Guardar"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}