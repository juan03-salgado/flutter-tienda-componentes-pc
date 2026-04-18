class Carrito {
  final int? id;
  final int idCliente;

  Carrito({
    this.id,
    required this.idCliente
  });

  factory Carrito.fromJson(Map<String, dynamic> json){
    return Carrito(
      id: int.tryParse(json['id'].toString()),
      idCliente: int.tryParse(json['id_cliente'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id_cliente':idCliente
    };
  }
}