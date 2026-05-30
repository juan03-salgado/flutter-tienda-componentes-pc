import 'dart:convert';

import 'package:tienda_pc/models/carrito.dart';
import 'package:http/http.dart' as http;

class CarritoService {
  final String api = 'http://10.0.2.2:3000';

  Future<List <Carrito>> getCarrito() async {
    final response = await http.get(Uri.parse('$api/carrito'));

    if(response.statusCode == 200){
      final List<dynamic> carrito = jsonDecode(response.body);

      return carrito.map((json) => Carrito.fromJson(json)).toList(); 

    } else {
      throw Exception("Error al obtener los carritos");
    }
  }

  Future<Carrito> getCarritoId(int id) async {
    final response = await http.get(Uri.parse('$api/carrito/$id'));

    if(response.statusCode == 200){
      final carrito = jsonDecode(response.body);
      return Carrito.fromJson(carrito);
    } else {
      throw Exception("Error al obtener el carrito con el id $id");
    }
  }

  Future<Carrito> crearCarrito(Carrito carrito) async {
    final response = await http.post(Uri.parse('$api/carrito'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(carrito.toJson())
    );

    if(response.statusCode == 200 || response.statusCode == 201){
      final carritoCreado = jsonDecode(response.body);
      return Carrito.fromJson(carritoCreado);
    } else {
      throw Exception("Error al crear el carrito");
    }
  }

  Future<Carrito> actualizarCarrito(Carrito carrito) async {
    if(carrito.id == null){
      throw Exception("El id del carrito es obligatorio");
    }

    final response = await http.put(Uri.parse('$api/carrito/${carrito.id}'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(carrito.toJson())
    );

    if(response.statusCode == 200 || response.statusCode == 201){
      final carritoActualizado = jsonDecode(response.body);
      return Carrito.fromJson(carritoActualizado);
    } else {
      throw Exception("Error al actualizar el carrito");
    }
  }

  Future<void> eliminarCarrito(int id) async {
    final response = await http.delete(Uri.parse('$api/carrito/$id'));

    if(response.statusCode != 200){
      throw Exception("Error al eliminar el carrito");
    }
  }
}