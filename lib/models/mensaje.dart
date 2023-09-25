class Mensaje {
  String nombreCliente;
  String mensaje;
  String fechaHora;

  Mensaje({
    required this.nombreCliente,
    required this.mensaje,
    required this.fechaHora,
  });

  factory Mensaje.fromJson(Map<String, dynamic> json) {
    return Mensaje(
      nombreCliente: json['NombreCliente'],
      mensaje: json['Mensaje'],
      fechaHora: json['FechaHora'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'NombreCliente': nombreCliente,
      'Mensaje': mensaje,
      'FechaHora': fechaHora,
    };
  }
}
