class ProductosModel {
  int idMobiliario;
  String nombreCliente;
  String fechaEntrega;
  String telefono1;
  String telefono2;
  String tipoEvento;
  String estado;
  int cantidadSillas;
  int cantidadMesas;
  int cantidadManteles;
  int cantidadToldos;

  ProductosModel({
    required this.idMobiliario,
    required this.nombreCliente,
    required this.fechaEntrega,
    required this.telefono1,
    required this.telefono2,
    required this.tipoEvento,
    required this.estado,
    required this.cantidadSillas,
    required this.cantidadMesas,
    required this.cantidadManteles,
    required this.cantidadToldos,
  });

  Map<String, dynamic> toMap() {
    return {
      'idMobiliario': idMobiliario,
      'nombreCliente': nombreCliente,
      'fechaEntrega': fechaEntrega,
      'telefono1': telefono1,
      'telefono2': telefono2,
      'tipoEvento': tipoEvento,
      'estado': estado,
      'cantidadSillas': cantidadSillas,
      'cantidadMesas': cantidadMesas,
      'cantidadManteles': cantidadManteles,
      'cantidadToldos': cantidadToldos,
    };
  }

  factory ProductosModel.fromMap(Map<String, dynamic> map) {
    return ProductosModel(
      idMobiliario: map['idMobiliario'],
      nombreCliente: map['nombreCliente'],
      fechaEntrega: map['fechaEntrega'],
      telefono1: map['telefono1'],
      telefono2: map['telefono2'],
      tipoEvento: map['tipoEvento'],
      estado: map['estado'],
      cantidadSillas: map['cantidadSillas'],
      cantidadMesas: map['cantidadMesas'],
      cantidadManteles: map['cantidadManteles'],
      cantidadToldos: map['cantidadToldos'],
    );
  }
  
}

class HistorialItem {
  final String cliente;
  final String fecha;
  final String tipoEvento;
  String estatus;

  HistorialItem({required this.cliente, required this.fecha, required this.tipoEvento, required this.estatus});

  void updateEstatus(String newEstatus) {
    estatus = newEstatus;
  }
}

List<HistorialItem> historial = [];

