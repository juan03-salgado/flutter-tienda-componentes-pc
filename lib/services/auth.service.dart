import 'dart:convert';

import 'package:tienda_pc/models/usuarios.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String api = 'https://backend-tienda-pc.onrender.com';

  Usuario? usuarioActual;
  
  Future<Usuario> login(String nombre, String contrasena) async {
    final response = await http.post(Uri.parse('$api/usuarios/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({ 'nombre_user': nombre.trim(), 'contrasena': contrasena.trim()})
    );

    if(response.statusCode == 200){
      final resultado = jsonDecode(response.body);
      usuarioActual = Usuario.fromJson(resultado['usuario']);
      return usuarioActual!;
    } else if(response.statusCode == 404) {
      throw Exception("El usuario no existe");
    } else {
      throw Exception("Login fallido");
    }
  }
  
  void logout() {
    usuarioActual = null;
  }

  Future<Usuario> register(String nombre, String email, String contrasena) async {
    final response = await http.post(Uri.parse('$api/usuarios'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({ 'nombre_user': nombre, 'email': email, 'contrasena': contrasena})
    );

    if(response.statusCode == 200 || response.statusCode == 201){
      final resultado = jsonDecode(response.body);
      return Usuario.fromJson(resultado['usuario']);
    } else {
      throw Exception("Registro fallido");
    }
  } 
}