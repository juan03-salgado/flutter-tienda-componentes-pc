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
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      nombre: json['nombre_user'],
      email: json['email'],
      contrasena: json['contrasena'],
      rol: json['id_rol'] is int ? json['id_rol'] : int.parse(json['id_rol'].toString()),
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
