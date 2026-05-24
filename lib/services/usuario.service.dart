import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tienda_pc/models/usuarios.dart';

class UsuarioService {
  // api local: 'http://10.0.2.2:3000'
  final String api = 'https://backend-tienda-pc.onrender.com';

  Future <List <Usuario>> getUsuarios() async {
    final response = await http.get(Uri.parse('$api/usuarios')); 

    if (response.statusCode == 200){
      final List<dynamic> usuarios = jsonDecode(response.body);

      return usuarios.map((json) => Usuario.fromJson(json)).toList();
      
    } else {
      throw Exception("Error al cargar los usuarios");
    }
  }

  Future<Usuario> getUsuarioId(int id) async {
    final response = await http.get(Uri.parse('$api/usuarios/$id'));

    if(response.statusCode == 200){
      final usuario = jsonDecode(response.body);
      return Usuario.fromJson(usuario);
    } else {
      throw Exception("Error al cargar el usuario con id: $id");
    }
  }

  Future<Usuario> crearUsuario(Usuario usuario) async {
    final response = await http.post(Uri.parse('$api/usuarios'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(usuario.toJson()),
  );
    if(response.statusCode == 201 || response.statusCode == 200){
      if(response.body.isNotEmpty){
        final usuarioCreado = jsonDecode(response.body);
        return Usuario.fromJson(usuarioCreado);
      } else {
        return usuario;
      }
    } else { 
      throw Exception("Error al crear el usuario");
    }
  }

  Future<Usuario> actualizarUsuario(Usuario usuario) async {
    if(usuario.id == null){
      throw Exception("El ID del usuario es obligatorio");
    }

    final response = await http.put(Uri.parse('$api/usuarios/${usuario.id}'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(usuario.toJson()), 
  );
    if(response.statusCode == 200 || response.statusCode == 201){
      final usuarioActualizado = jsonDecode(response.body);
      return Usuario.fromJson(usuarioActualizado);
    } else {
      throw Exception("Error al actualizar el usuario");
    }
  }

  Future<void> convertirVendedor(int id, String telefono, String direccion, String nombreTienda) async {
    final response = await http.put(Uri.parse('$api/usuarios/$id/convertirVendedor'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'telefono': telefono, 'direccion': direccion, 'nombre_tienda': nombreTienda})
    );

    if(response.statusCode != 200){
      throw Exception("Error al convertir en vendedor");
    }
  }

  Future<void> eliminarUsuario(int id) async {
    final response = await http.delete(Uri.parse('$api/usuarios/$id'));

    if(response.statusCode != 200){
      throw Exception("Error al eliminar el usuario");
    }
  }
}