import 'package:tienda_pc/models/productos.dart';

class CarritoProducto {
  final int? id;
  final int idCarrito;
  final int idProducto;
  final int cantidad;
  final double? precioTotal;
  final Producto producto;

  CarritoProducto({
    this.id,
    required this.cantidad,
    this.precioTotal,
    required this.idCarrito,
    required this.idProducto,
    required this.producto
  });

  factory CarritoProducto.fromJson(Map<String, dynamic> json){
    return CarritoProducto(
      id: int.tryParse(json['id'].toString()),
      idCarrito: int.tryParse(json['id_carrito'].toString()) ?? 0,
      idProducto: int.tryParse(json['producto']?['id']?.toString() ?? '') ?? 0,
      cantidad: int.tryParse(json['cantidad'].toString()) ?? 0,
      precioTotal: double.tryParse(json['precio_total'].toString()) ?? 0,
      producto: Producto.fromJson(json['producto'] ?? {}),
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id_producto': idProducto,
      'id_carrito': idCarrito,
      'cantidad': cantidad,
    };
  }
}