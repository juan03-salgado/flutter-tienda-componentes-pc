class Detallecompra {
  final int idProducto;
  final String producto;
  final String categoria;
  final int cantidad;
  final double precioTotal;

  Detallecompra({
    required this.idProducto,
    required this.producto,
    required this.categoria,
    required this.cantidad,
    required this.precioTotal
  });
  
  factory Detallecompra.fromJson(Map<String, dynamic> json){
    return Detallecompra(
      idProducto: int.tryParse(json['id_producto']?.toString() ?? '') ?? 0,
      producto: json['producto'] ?? '',
      categoria: json['categoria'] ?? '',
      cantidad: int.tryParse(json['cantidad']?.toString() ?? '') ?? 0,
      precioTotal: double.tryParse(json['precio_total'].toString()) ?? 0,
    );
  }
}