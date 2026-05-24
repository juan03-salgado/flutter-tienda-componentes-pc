import 'package:intl/intl.dart';

class Notificacion {
  final int? id;
  final String mensaje;
  final bool leido;
  final String fecha;
  final int idUsuario;

  Notificacion({
    required this.id,
    required this.mensaje,
    required this.leido,
    required this.fecha,
    required this.idUsuario
  });

  String get fechaFormateada => DateFormat('dd/MM/yyyy').format(DateTime.parse(fecha));

  factory Notificacion.fromJson(Map<String, dynamic> json) {
    return Notificacion(
      id: int.tryParse(json['id'].toString()), 
      mensaje: json['mensaje'] ?? "", 
      leido: json['leido'] == 1 || json['leido'] == true,
      fecha: json['fecha'] ?? "",
      idUsuario: int.tryParse(json['id_usuario'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "mensaje": mensaje,
      "leido": leido ? 1 : 0,
      "fecha": fecha,
      "id_usuario": idUsuario
    };
  }
}