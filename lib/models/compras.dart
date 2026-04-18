import 'package:tienda_pc/models/detalleCompra.dart';

class Compras {
  final int? id;
  final int idCompra;
  final int idCarrito;
  final String referenciaPago;
  final String fechaCompra;
  final String estado;
  final String cliente;
  final List<Detallecompra> productos;

  Compras({
    this.id,
    required this.idCompra,
    required this.idCarrito,
    required this.referenciaPago,
    required this.fechaCompra,
    required this.estado,
    required this.cliente,
    required this.productos
  });

  factory Compras.fromJson(Map<String, dynamic> json){
    return Compras(
      idCompra: json['id_compra'],
      idCarrito: json['id_carrito'],
      referenciaPago: json['referencia_pago'],
      fechaCompra: json['fecha_compra'],
      estado: json['estado'],
      cliente: json['cliente'] ?? '',
      productos: (json['productos'] as List).map((p) => Detallecompra.fromJson(p)).toList()
    );
  }
}