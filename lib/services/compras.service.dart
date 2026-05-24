import 'dart:convert';

import 'package:tienda_pc/models/compras.dart';
import 'package:http/http.dart' as http;

class ComprasService {
  final String api = 'https://backend-tienda-pc.onrender.com';

  Future<List <Compras>> getCompras() async {
    final response = await http.get(Uri.parse('$api/compras'));

    if(response.statusCode == 200){
      final List<dynamic> compras = jsonDecode(response.body);
      return compras.map((json) => Compras.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener las compras");
    }
  }

  Future<List <Compras>> getCompraId(int idCarrito) async {
    final response = await http.get(Uri.parse('$api/compras/$idCarrito'));

    if(response.statusCode == 200){
      final List<dynamic> compras = jsonDecode(response.body);
      return compras.map((json) => Compras.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener compras del usuario");
    }
  }

  Future<List <Compras>> getCompraUsuario(int idUsuario) async {
    final response = await http.get(Uri.parse('$api/compras/cliente/$idUsuario'));

    if(response.statusCode == 200){
      final List<dynamic> compras = jsonDecode(response.body);
      return compras.map((json) => Compras.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener compras del usuario");
    }
  }

  Future<List <Compras>> getVentasVendedor(int idVendedor) async {
    final response = await http.get(Uri.parse('$api/compras/vendedor/$idVendedor'));

    if(response.statusCode == 200){
      final List<dynamic> compras = jsonDecode(response.body);
      return compras.map((json) => Compras.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener ventas del vendedor");
    }
  }

  Future<void> realizarCompra(int idCarrito) async {
    final response = await http.post(Uri.parse('$api/compras'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'id_carrito': idCarrito})
    );
    if(response.statusCode != 200 && response.statusCode != 201){
      throw Exception("Error al realizar la compra");
    }
  }

  Future<void> actualizarEstado(int id, String estado) async {
    final response = await http.put(Uri.parse('$api/compras/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'estado': estado})
    );
    if(response.statusCode != 200){
      throw Exception("Error al actualizar el estado");
    }
  }

  Future<void> eliminarCompra(int id) async {
    final response = await http.delete(Uri.parse('$api/compras/$id'));
    if(response.statusCode != 200){
      throw Exception("Error al eliminar la compra");
    }
  }

}