import 'dart:convert';

import 'package:tienda_pc/models/cliente.dart';
import 'package:http/http.dart' as http;

class ClientesService {
  final String api = 'http://10.0.2.2:3000';

  Future <List <Cliente>> getClientes() async {
    final response = await http.get(Uri.parse('$api/clientes')); 

    if (response.statusCode == 200){
      final List<dynamic> clientes = jsonDecode(response.body);

      return clientes.map((json) => Cliente.fromJson(json)).toList();
      
    } else {
      throw Exception("Error al cargar los clientes");
    }
  }

  Future<Cliente> getClienteId(int id) async {
    final response = await http.get(Uri.parse('$api/clientes/$id'));

    if(response.statusCode == 200){
      final cliente = jsonDecode(response.body);
      return Cliente.fromJson(cliente);
    } else {
      throw Exception("Error al cargar el cliente con id: $id");
    }
  }

  Future<Cliente> crearCliente(Cliente cliente) async {
    final response = await http.post(Uri.parse('$api/clientes'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(cliente.toJson()),
  );
    if(response.statusCode == 201 || response.statusCode == 200){
      if(response.body.isNotEmpty){
        final clienteCreado = jsonDecode(response.body);
        return Cliente.fromJson(clienteCreado);
      } else {
        return cliente;
      }
    } else { 
      throw Exception("Error al crear el cliente");
    }
  }

  Future<Cliente> actualizarCliente(Cliente cliente) async {
    if(cliente.id == null){
      throw Exception("El ID del cliente es obligatorio");
    }

    final response = await http.put(Uri.parse('$api/clientes/${cliente.id}'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(cliente.toJson()), 
  );
    if(response.statusCode == 200 || response.statusCode == 201){
      final clienteActualizado = jsonDecode(response.body);
      return Cliente.fromJson(clienteActualizado);
    } else {
      throw Exception("Error al actualizar el cliente ${response.body}");
    }
  }

  Future<void> eliminarCliente(int id) async {
    final response = await http.delete(Uri.parse('$api/clientes/$id'));

    if(response.statusCode != 200){
      throw Exception("Error al eliminar el cliente");
    }
  }
}