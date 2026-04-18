class Producto {
  final int? id;
  final String nombre;
  final String descripcion;
  final int? idCategoria;
  final String? categoriaNombre; 
  final double precioUnidad;
  final int unidades;
  final String? imagen;
  final String? imagenUrl;

  Producto({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.idCategoria,
    required this.categoriaNombre,
    required this.precioUnidad,
    required this.unidades,
    this.imagen,
    this.imagenUrl
  });

  factory Producto.fromJson(Map<String, dynamic> json){
    return Producto(
      id: int.tryParse(json['id']?.toString() ?? ''),
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      idCategoria: int.tryParse(json['id_categoria']?.toString() ?? ''),
      categoriaNombre: json['categoria_nombre'] ?? '',
      precioUnidad: double.tryParse(json['precio_unidad'].toString()) ?? 0,
      unidades: int.tryParse(json['unidades'].toString()) ?? 0,
      imagen: json['imagen'],
      imagenUrl: json['imagenUrl']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'id_categoria': idCategoria,
      'precio_unidad': precioUnidad,
      'unidades': unidades,
      'imagen': imagen
    };
  }
}