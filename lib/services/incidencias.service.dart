import 'dart:convert';
import 'package:tienda_pc/models/incidencias.dart';
import 'package:http/http.dart' as http;

class IncidenciasService {
  final String api = 'http://10.0.2.2:3000';

  Future<List <Incidencia>> getIncidencias() async {
    final response = await http.get(Uri.parse('$api/incidencias'));

    if(response.statusCode == 200){
      final List<dynamic> incidencias = jsonDecode(response.body);
      return incidencias.map((json) => Incidencia.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener las incidencias");
    }
  }
  
  Future<Incidencia> getIncidenciaId(int id) async {
    final response = await http.get(Uri.parse('$api/incidencias/$id'));

    if(response.statusCode == 200){
      final incidencia = jsonDecode(response.body);
      return Incidencia.fromJson(incidencia);
    } else {
      throw Exception("Error al obtener la incidencia con el id $id");
    }
  }

  Future<List <Incidencia>> getIncidenciasCliente(int idUsuario) async {
    final response = await http.get(Uri.parse('$api/incidencias/cliente/$idUsuario'));

    if(response.statusCode == 200){
      final List <dynamic> incidencias = jsonDecode(response.body);
      return incidencias.map((json) => Incidencia.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener las incidencias del cliente");
    }
  }

  Future<List <Incidencia>> getIncidenciasVendedor(int idVendedor) async {
    final response = await http.get(Uri.parse('$api/incidencias/vendedor/$idVendedor'));

    if(response.statusCode == 200){
      final List <dynamic> incidencias = jsonDecode(response.body);
      return incidencias.map((json) => Incidencia.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener las incidencias del vendedor");
    }
  }

  Future<void> crearIncidencia(Incidencia incidencia) async {
    final response = await http.post(Uri.parse('$api/incidencias'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(incidencia.toJson()),
  );
    if(response.statusCode != 200 && response.statusCode != 201){
      throw Exception("Error al crear la incidencia");
    }
  }

  Future<void> actualizarEstado(int id, String estado, String mensaje) async {
    final response = await http.put(Uri.parse('$api/incidencias/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'estado': estado, 'mensaje': mensaje}),
  );
    if(response.statusCode != 200 && response.statusCode != 201){
      throw Exception("Error al actualizar el estado de la incidencia");
    } 
  }

  Future<void> eliminarIncidencia(int id) async {
    final response = await http.delete(Uri.parse('$api/incidencias/$id'));

    if(response.statusCode != 200){
      throw Exception("Error al eliminar la incidencia con el id $id");
    }
  }
}