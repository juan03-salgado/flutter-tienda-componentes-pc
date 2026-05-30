import 'dart:convert';
import 'dart:io';
import 'package:tienda_pc/models/productos.dart';
import 'package:http/http.dart' as http;

class ProductoService {
  final String api = 'http://10.0.2.2:3000';

  Future<List <Producto>> getProductos() async {
    final response = await http.get(Uri.parse('$api/productos'));

    if(response.statusCode == 200){
      final List<dynamic> productos = jsonDecode(response.body);

      return productos.map((json) => Producto.fromJson(json)).toList();

    } else {
      throw Exception("Error al cargar los productos");
    }
  }

  Future<Producto> getProductoId(int id) async {
    final response = await http.get(Uri.parse('$api/productos/$id'));

    if(response.statusCode == 200){
      final producto = jsonDecode(response.body);
      return Producto.fromJson(producto);
    } else {
      throw Exception("Error al cargar el producto con el id $id");
    }
  }

  Future<List <Producto>> getProductoVendedor(int idVendedor) async {
    final response = await http.get(Uri.parse('$api/productos/vendedor/$idVendedor'));

    if(response.statusCode == 200){
      final List <dynamic> productos = jsonDecode(response.body);
      return productos.map((json) => Producto.fromJson(json)).toList();
    } else {
      throw Exception("Error al cargar el producto con el id $idVendedor");
    }
  }

  Future<void> crearProducto(Producto producto, File? imagen) async {
    final request = http.MultipartRequest('POST', Uri.parse('$api/productos'));

    request.fields['nombre'] = producto.nombre;
    request.fields['descripcion'] = producto.descripcion;
    request.fields['id_categoria'] = producto.idCategoria.toString();
    request.fields['precio_unidad'] = producto.precioUnidad.toString();
    request.fields['unidades'] = producto.unidades.toString();
    request.fields['id_vendedor'] = producto.id_vendedor.toString();
    request.fields['otra_categoria'] = producto.otraCategoria ?? '';

    if(imagen != null){
      request.files.add(await http.MultipartFile.fromPath('imagen', imagen.path));
    }

    final response = await request.send();

    if(response.statusCode != 200 && response.statusCode != 201){
      throw Exception("Error al crear el producto");
    }
  }

  Future<void> actualizarProducto(Producto producto, File? imagen) async {
    if(producto.id == null){
      throw Exception("El id del producto es obligatorio");
    }

    final request = http.MultipartRequest('PUT', Uri.parse('$api/productos/${producto.id}'));

    request.fields['nombre'] = producto.nombre;
    request.fields['descripcion'] = producto.descripcion;
    request.fields['id_categoria'] = producto.idCategoria.toString();
    request.fields['precio_unidad'] = producto.precioUnidad.toString();
    request.fields['unidades'] = producto.unidades.toString();
    request.fields['otra_categoria'] = producto.otraCategoria ?? '';

    if(imagen != null){
      request.files.add(await http.MultipartFile.fromPath('imagen', imagen.path));
    }

    final response = await request.send();

    if(response.statusCode != 200 && response.statusCode != 201){
      throw Exception("Error al actualizar el producto");
    }
  }

  Future<void> eliminarProducto(int id) async {
    final response = await http.delete(Uri.parse('$api/productos/$id'));
  
    if(response.statusCode != 200){
      throw Exception("Error al eliminar el producto");
    }
  }

}