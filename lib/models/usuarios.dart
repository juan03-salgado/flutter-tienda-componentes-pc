class Usuario {
  final int? id;
  final String nombre;
  final String email;
  final String contrasena;
  final int rol;

  Usuario({
    this.id,
    required this.nombre,
    required this.email,
    required this.contrasena,
    required this.rol,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: int.tryParse(json['id'].toString()),
      nombre: json['nombre_user'],
      email: json['email'],
      contrasena: json['contrasena'],
      rol: int.tryParse(json['id_rol'].toString()) ?? 0,
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
