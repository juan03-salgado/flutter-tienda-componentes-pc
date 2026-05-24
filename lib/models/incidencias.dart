import 'package:tienda_pc/models/productos.dart';
import 'package:tienda_pc/models/usuarios.dart';

class Incidencia {
  final int? id;
  final String descripcion;
  final String? fechaReporte;
  final String estado;
  final Usuario usuario;
  final Producto producto;

  const Incidencia({
    this.id,
    required this.descripcion,
    this.fechaReporte,
    required this.estado,
    required this.usuario,
    required this.producto,
  });

  factory Incidencia.fromJson(Map<String, dynamic> json){
    return Incidencia(
      id: int.tryParse(json['id']?.toString() ?? ''),
      descripcion: json['descripcion'] ?? '',
      fechaReporte: json['fecha_reporte'] ?? '',
      estado: json['estado'] ?? 'PENDIENTE',
      usuario: Usuario.fromJson(Map<String, dynamic>.from(json['usuario'] ?? {})),
      producto: Producto.fromJson(Map<String, dynamic>.from(json['producto'] ?? {})),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_usuario': usuario.id,
      'id_producto': producto.id,
      'descripcion': descripcion,
    };
  }
}