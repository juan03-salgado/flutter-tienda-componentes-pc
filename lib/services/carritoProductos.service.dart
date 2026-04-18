import 'dart:convert';
import 'package:tienda_pc/models/carritoProducto.dart';
import 'package:http/http.dart' as http;

class CarritoProductosService {
  final String api = 'http://10.0.2.2:3000';

  Future<List <CarritoProducto>> getCarritoProductos() async {
    final response = await http.get(Uri.parse('$api/productosCarrito'));

    if(response.statusCode == 200){
      final List<dynamic> carritoProductos = jsonDecode(response.body);
      
      return carritoProductos.map((json) => CarritoProducto.fromJson(json)).toList();
    
    } else {
      throw Exception("Error al obtener productos del carrito");
    }
  }

  Future<CarritoProducto> getCarritoProductoId(int id) async {
    final response = await http.get(Uri.parse('$api/productosCarrito/$id'));

    if(response.statusCode == 200){
      final carritoProducto = jsonDecode(response.body);
      return CarritoProducto.fromJson(carritoProducto);
    } else {
      throw Exception("Error al obtener los productos del carrito con el id $id");
    }
  }

  Future<CarritoProducto> agregarProductoCarrito(CarritoProducto carritoProducto) async {
    final response = await http.post(Uri.parse('$api/productosCarrito'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(carritoProducto.toJson())
    );

    if(response.statusCode == 200 || response.statusCode == 201){
      final productoAgregadoCarrito = jsonDecode(response.body);
      return CarritoProducto.fromJson(productoAgregadoCarrito);
    } else {
      throw Exception("Error al agregar producto a carrito");
    }
  }

  Future<CarritoProducto> actualizarProductoCarrito(CarritoProducto carritoProducto) async {
    if(carritoProducto.id == null){
      throw Exception("El id es obligatorio");
    }

    final response = await http.put(Uri.parse('$api/productosCarrito/${carritoProducto.id}'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(carritoProducto.toJson())
    );

    if(response.statusCode == 200 || response.statusCode == 201){
      final productosCarritoActualizado = jsonDecode(response.body);
      return CarritoProducto.fromJson(productosCarritoActualizado);
    } else {
      throw Exception("Error al actualizar los productos del carrito");
    }
  }

  Future<void> eliminarProductoCarrito(int id) async {
    final response = await http.delete(Uri.parse('$api/productosCarrito/$id'));

    if(response.statusCode != 200){
      throw Exception("Error al eliminar el producto del carrito");
    }
  }
}