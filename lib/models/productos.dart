class Producto {
  final int? id;
  final String nombre;
  final String descripcion;
  final int? idCategoria;
  final String? categoriaNombre; 
  final String? otraCategoria;
  final double precioUnidad;
  final int unidades;
  final String? nombreTienda;
  final String? imagen;
  final String? imagenUrl;
  final int? id_vendedor;

  Producto({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.idCategoria,
    required this.categoriaNombre,
    this.otraCategoria,
    required this.precioUnidad,
    required this.unidades,
    this.nombreTienda,
    this.imagen,
    this.imagenUrl,
    this.id_vendedor
  });

  String get categoriaMostrada {
  if (idCategoria == 6) {
    return otraCategoria?.trim().isNotEmpty == true ? otraCategoria! : "Otro";
  }
    return categoriaNombre ?? "Sin categoría";
  }

  factory Producto.fromJson(Map<String, dynamic> json){
      final categoria = json['categoria'];

    return Producto(
      id: int.tryParse(json['id']?.toString() ?? ''),
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      idCategoria: json['id_categoria'] != null ? int.tryParse(json['id_categoria'].toString()): null,      
      categoriaNombre: categoria is Map ? categoria['nombre']: json['categoria_nombre'] ?? categoria ?? '',
      precioUnidad: double.tryParse(json['precio_unidad'].toString()) ?? 0,
      unidades: int.tryParse(json['unidades'].toString()) ?? 0,
      nombreTienda: json['nombre_tienda'],
      imagen: json['imagen'],
      imagenUrl: json['imagenUrl'],
      id_vendedor: int.tryParse(json['id_vendedor']?.toString() ?? ''),
      otraCategoria: json['otra_categoria']?.toString()
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'id_categoria': idCategoria,
      'precio_unidad': precioUnidad,
      'unidades': unidades,
      'imagen': imagen,
      'id_vendedor': id_vendedor,
      'otra_categoria': otraCategoria
    };
  }
}