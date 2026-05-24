import 'dart:convert';

import 'package:tienda_pc/models/notificacion.dart';
import 'package:http/http.dart' as http;

class NotificacionesService {
  final String api = 'https://backend-tienda-pc.onrender.com';

  Future<List <Notificacion>> getNotificaciones(int idUsuario) async {
    final response = await http.get(Uri.parse('$api/notificaciones/usuario/${idUsuario}'));

    if(response.statusCode == 200){
      final List<dynamic> notificaciones = jsonDecode(response.body);
      return notificaciones.map((json) => Notificacion.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener las notificaciones");
    }
  }

  Future<int> contarNoLeidas(int idUsuario) async {
    final response = await http.get(Uri.parse('$api/notificaciones/contador/$idUsuario'));

    if(response.statusCode == 200){
      final notificacion = jsonDecode(response.body);
      return notificacion['total'] ?? 0;
    } else {
      throw Exception("Error al contar las notificaciones");
    }
  }

  Future<void> marcarLeida(int id) async {
    final response = await http.put(Uri.parse('$api/notificaciones/leida/$id'));

    if (response.statusCode != 200) {
      throw Exception("Error al marcar notificación");
    }
  }

  Future<void> eliminarNotificacion(int id) async {
    final response = await http.delete(Uri.parse('$api/notificaciones/$id'));

    if (response.statusCode != 200) {
      throw Exception("Error al eliminar notificación");
    }
  }
}