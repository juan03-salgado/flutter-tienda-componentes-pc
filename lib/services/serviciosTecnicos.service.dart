import 'dart:convert';
import 'package:tienda_pc/models/serviciosTecnicos.dart';
import 'package:http/http.dart' as http;

class ServiciostecnicosService {
  final String api = 'http://10.0.2.2:3000';

  Future<List<Serviciostecnicos>> getServiciosTecnicos() async {
    final response = await http.get(Uri.parse('$api/servicios'));

    if(response.statusCode == 200){
      final List<dynamic> serviciosTecnicos = jsonDecode(response.body);
      return serviciosTecnicos.map((json) => Serviciostecnicos.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener los servicios técnicos");
    }
  }

  Future<Serviciostecnicos> getServicioTecnicoId(int id) async {
    final response = await http.get(Uri.parse('$api/servicios/$id'));

    if(response.statusCode == 200){
      final servicioTecnico = jsonDecode(response.body);
      return Serviciostecnicos.fromJson(servicioTecnico);
    } else {
      throw Exception("Error al obtener el servicio técnico con el id $id");
    }
  }

  Future<List <Serviciostecnicos>> getServiciosCliente(int idCliente) async {
    final response = await http.get(Uri.parse('$api/servicios/cliente/$idCliente'));

    if(response.statusCode == 200){
      final List<dynamic> servicios = jsonDecode(response.body);
      return servicios.map((json) => Serviciostecnicos.fromJson(json)).toList(); 
    } else {
      throw Exception("Error al obtener los servicios del usuario");
    }
  }

  Future<List <Serviciostecnicos>> getServiciosVendedor(int idVendedor) async {
    final response = await http.get(Uri.parse('$api/servicios/vendedor/$idVendedor'));

    if(response.statusCode == 200){
      final List<dynamic> servicios = jsonDecode(response.body);
      return servicios.map((json) => Serviciostecnicos.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener servicios del vendedor");
    }
  }

  Future<void> crearServicioTecnico(Serviciostecnicos servicioTecnico) async {
    final response = await http.post(Uri.parse('$api/servicios'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(servicioTecnico.toJson()),
    );

    if(response.statusCode != 200 && response.statusCode != 201){
      throw Exception("Error al crear el servicio técnico");
    }
  }

  Future<void> actualizarEstado(int id, String estado, String mensaje) async {
    final response = await http.put(Uri.parse('$api/servicios/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'estado': estado, 'mensaje': mensaje}),
    );
    if(response.statusCode != 200 && response.statusCode != 201){
      throw Exception("Error al actualizar el estado del servicio técnico");
    } 
  }

  Future<void> eliminarServicioTecnico(int id) async {
    final response = await http.delete(Uri.parse('$api/servicios/$id'));

    if(response.statusCode != 200){
      throw Exception("Error al eliminar el servicio técnico con el id $id");
    }
  }
}