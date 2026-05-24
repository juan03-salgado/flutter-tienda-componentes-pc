import 'package:intl/intl.dart';
import 'package:tienda_pc/models/productos.dart';
import 'package:tienda_pc/models/usuarios.dart';

class Serviciostecnicos {
  final int? id;
  final String tipoServicio;
  final String descripcion;
  final String fechaSolicitud;
  final String estado;
  final Usuario usuario;
  final Producto? producto;

  Serviciostecnicos({
    this.id,
    required this.tipoServicio,
    required this.descripcion,
    required this.fechaSolicitud,
    required this.estado,
    required this.usuario,
    this.producto
  });

  String get fechaFormateada => DateFormat('dd/MM/yyyy').format(DateTime.parse(fechaSolicitud));

  factory Serviciostecnicos.fromJson(Map<String, dynamic> json) {
    return Serviciostecnicos(
      id: int.tryParse(json['id']?.toString() ?? ''),
      tipoServicio: json['tipo_servicio'] ?? '',
      descripcion: json['descripcion'] ?? '',
      fechaSolicitud: json['fecha_solicitud'] ?? '',
      estado: json['estado'] ?? '',
      usuario: Usuario.fromJson(json['usuario'] ?? {}),
      producto: json['producto'] != null ? Producto.fromJson(json['producto']): null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_usuario': usuario.id,
      'id_producto': producto?.id,
      'tipo_servicio': tipoServicio,
      'descripcion': descripcion
    };
  }
}