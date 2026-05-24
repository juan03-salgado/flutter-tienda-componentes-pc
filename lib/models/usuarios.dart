class Usuario {
  final int? id;
  final String nombre;
  final String email;
  final String contrasena;
  final int rol;
  final int? idCarrito;

  Usuario({
    this.id,
    required this.nombre,
    required this.email,
    required this.contrasena,
    required this.rol,
    this.idCarrito
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: int.tryParse(json['id'].toString()),
      nombre: json['nombre_user'] ?? json['nombre'] ?? '',
      email: json['email'] ?? '',
      contrasena: json['contrasena'] ?? '',
      rol: int.tryParse(json['id_rol'].toString()) ?? 0,
      idCarrito: json['id_carrito'] != null ? int.tryParse(json['id_carrito'].toString()) : null
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'nombre_user': nombre,
      'email': email,
      'contrasena': contrasena,
      'id_rol': rol
    };
  }
}
