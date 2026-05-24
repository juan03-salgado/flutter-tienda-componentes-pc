class Cliente {
  final int? id;
  final String nombre;
  final String direccion;
  final String telefono;
  final int idUsuario;

  Cliente({
    this.id,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.idUsuario,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: int.tryParse(json['id'].toString()),
      nombre: json['nombre_user'] ?? json['nombre'] ?? '',
      direccion: json['direccion'] ?? "",
      telefono: json['telefono'] ?? "",
      idUsuario: int.tryParse(json['id_user'].toString()) ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {
      "nombre": nombre,
      "direccion": direccion,
      "telefono": telefono,
      "id_user": idUsuario,
    };
  }
}