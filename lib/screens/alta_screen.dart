import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobiliarios/database/mobiliario_database.dart';
import 'package:mobiliarios/model/mobiliario_model.dart';
import 'package:mobiliarios/setting/app_value_notifier.dart';

class AltaScreen extends StatefulWidget {
  const AltaScreen({Key? key}) : super(key: key);

  @override
  State<AltaScreen> createState() => _AltaScreenState();
}

class _AltaScreenState extends State<AltaScreen> {
  ProductsDatabase? productsDB;

  @override
  void initState() {
    super.initState();
    productsDB = ProductsDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Renta de mobiliario'),
        actions: [
          IconButton(
            onPressed: () {
              _showAddProductDialog(context);
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              _showHistorial(context);
            },
            icon: const Icon(Icons.history),
          ),
          IconButton(
            onPressed: () {
              
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: AppValueNotifier.banProducts,
        builder: (context, value, _) {
          return FutureBuilder(
            future: productsDB!.consultar(),
            builder: (context, AsyncSnapshot<List<ProductosModel>> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Algo salió mal'),
                );
              } else {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return _itemMobiliario(snapshot.data![index]);
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }
            },
          );
        },
      ),
    );
  }

  Widget _itemMobiliario(ProductosModel producto) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey[350],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
      ),
      height: 800,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cliente: ${producto.nombreCliente}',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'Fecha de entrega: ${producto.fechaEntrega}',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'Teléfono 1: ${producto.telefono1}',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'Teléfono 2: ${producto.telefono2}',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'Tipo de evento: ${producto.tipoEvento}',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'Sillas Rentadas: ${producto.cantidadSillas}',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'Mesas Rentadas: ${producto.cantidadMesas}',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'Manteles Rentados: ${producto.cantidadManteles}',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'Toldos Rentados: ${producto.cantidadToldos}',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'Status: ${producto.estado}',
            style: TextStyle(fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  _showAddProductDialog(context, producto: producto);
                },
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () async {
                  _showDeleteConfirmationDialog(context, producto);
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog(BuildContext context, {ProductosModel? producto}) {
  final conNombre = TextEditingController();
  final conFecha = TextEditingController();
  final conTelefono1 = TextEditingController();
  final conTelefono2 = TextEditingController();
  final conTipoEvento = TextEditingController();
  final conEstado = TextEditingController();
  final conCantidadSillas = TextEditingController();
  final conCantidadMesas = TextEditingController();
  final conCantidadManteles = TextEditingController();
  final conCantidadToldos = TextEditingController();

  bool seleccionarSillas = false;
  bool seleccionarMesas = false;
  bool seleccionarManteles = false;
  bool seleccionarToldos = false;

  List<String> opcionesEstado = ['Pendiente', 'Cumplido', 'Cancelado'];

  String estadoSeleccionado = producto != null ? producto.estado : opcionesEstado[0];

  if (producto != null) {
    conNombre.text = producto.nombreCliente;
    conFecha.text = producto.fechaEntrega;
    conTelefono1.text = producto.telefono1;
    conTelefono2.text = producto.telefono2;
    conTipoEvento.text = producto.tipoEvento;
    conEstado.text = producto.estado;
    conCantidadSillas.text = producto.cantidadSillas.toString();
    seleccionarSillas = producto.cantidadSillas > 0;
    conCantidadMesas.text = producto.cantidadMesas.toString();
    seleccionarMesas = producto.cantidadMesas > 0;
    conCantidadManteles.text = producto.cantidadManteles.toString();
    seleccionarManteles = producto.cantidadManteles > 0;
    conCantidadToldos.text = producto.cantidadToldos.toString();
    seleccionarToldos = producto.cantidadToldos > 0;
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(producto == null ? 'Agregar Renta' : 'Editar Renta'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: conNombre,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del Cliente',
                    ),
                  ),
                  TextField(
                    controller: conFecha,
                    decoration: const InputDecoration(
                      labelText: 'Fecha de Renta',
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null) {
                        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          conFecha.text = formattedDate;
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                  ),
                  TextField(
                    controller: conTelefono1,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono 1',
                    ),
                  ),
                  TextField(
                    controller: conTelefono2,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono 2',
                    ),
                  ),
                  TextField(
                    controller: conTipoEvento,
                    decoration: const InputDecoration(
                      labelText: 'Tipo Evento',
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: seleccionarSillas,
                        onChanged: (bool? value) {
                          setState(() {
                            seleccionarSillas = value!;
                          });
                        },
                      ),
                      Text('¿Seleccionar sillas?'),
                    ],
                  ),
                  if (seleccionarSillas)
                    TextField(
                      controller: conCantidadSillas,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Cantidad de Sillas',
                      ),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: seleccionarMesas,
                        onChanged: (bool? value) {
                          setState(() {
                            seleccionarMesas = value!;
                          });
                        },
                      ),
                      Text('¿Seleccionar mesas?'),
                    ],
                  ),
                  if (seleccionarMesas)
                    TextField(
                      controller: conCantidadMesas,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Cantidad de Mesas',
                      ),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: seleccionarManteles,
                        onChanged: (bool? value) {
                          setState(() {
                            seleccionarManteles = value!;
                          });
                        },
                      ),
                      Text('¿Seleccionar manteles?'),
                    ],
                  ),
                  if (seleccionarManteles)
                    TextField(
                      controller: conCantidadManteles,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Cantidad de Manteles',
                      ),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: seleccionarToldos,
                        onChanged: (bool? value) {
                          setState(() {
                            seleccionarToldos = value!;
                          });
                        },
                      ),
                      Text('¿Seleccionar toldos?'),
                    ],
                  ),
                  if (seleccionarToldos)
                    TextField(
                      controller: conCantidadToldos,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Cantidad de Toldos',
                      ),
                    ),
                  const SizedBox(height: 10),
                  Text(
                    'Status:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<String>(
                    value: estadoSeleccionado,
                    onChanged: (String? newValue) {
                      setState(() {
                        estadoSeleccionado = newValue!;
                      });
                    },
                    items: opcionesEstado.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  _saveProduct(
                    context,
                    producto,
                    conNombre.text,
                    conFecha.text,
                    conTelefono1.text,
                    conTelefono2.text,
                    conTipoEvento.text,
                    estadoSeleccionado,
                    seleccionarSillas ? int.parse(conCantidadSillas.text) : 0,
                    seleccionarMesas ? int.parse(conCantidadSillas.text) : 0,
                    seleccionarManteles ? int.parse(conCantidadManteles.text) : 0,
                    seleccionarToldos ? int.parse(conCantidadToldos.text) : 0,
                  );
                },
                child: Text(producto == null ? 'Agregar' : 'Guardar'),
              ),
            ],
          );
        },
      );
    },
  );
}



  void _saveProduct(BuildContext context, ProductosModel? producto, String nombre, String fecha, String telefono1, String telefono2, String tipoEvento, String estado, int cantidadSillas, int cantidadMesas, int cantidadManteles, int cantidadToldos) {
  if (producto == null) {
    productsDB!
      .insertar({
        "nombreCliente": nombre,
        "fechaEntrega": fecha,
        "telefono1": telefono1,
        "telefono2": telefono2,
        "tipoEvento": tipoEvento,
        "estado": estado,
        "cantidadSillas": cantidadSillas,
        "cantidadMesas": cantidadMesas,
        "cantidadManteles": cantidadManteles,
        "cantidadToldos": cantidadToldos,
      })
      .then((value) {
        Navigator.pop(context);
        String msj = "";
        if (value > 0) {
          AppValueNotifier.banProducts.value =
            !AppValueNotifier.banProducts.value;
          msj = "Servicio Aceptado";
          
          // Agregar el nuevo elemento al historial
          historial.add(HistorialItem(cliente: nombre, fecha: fecha, tipoEvento: tipoEvento, estatus: estado));
        } else {
          msj = "Ocurrió un error";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msj),
          ),
        );
      });
  } else {
    productsDB!
      .actualizar({
        "idMobiliario": producto.idMobiliario,
        "nombreCliente": nombre,
        "fechaEntrega": fecha,
        "telefono1": telefono1,
        "telefono2": telefono2,
        "tipoEvento": tipoEvento,
        "estado": estado,
        "cantidadSillas": cantidadSillas,
        "cantidadMesas": cantidadMesas,
        "cantidadManteles": cantidadManteles,
        "cantidadToldos": cantidadToldos,
      })
      .then((value) {
        Navigator.pop(context);
        String msj = "";
        if (value > 0) {
          AppValueNotifier.banProducts.value =
            !AppValueNotifier.banProducts.value;
          msj = "Servicio Actualizado";
          
          for (var item in historial) {
            if (item.cliente == nombre && item.fecha == fecha && item.tipoEvento == tipoEvento) {
              item.estatus = estado;
              break;
            }
          }
        } else {
          msj = "Ocurrió un error";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msj),
          ),
        );
      });
  }
}



  void _showDeleteConfirmationDialog(BuildContext context, ProductosModel producto) async {
    bool confirmarEliminacion = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("¿Estás seguro?"),
          content: const Text("¡No podrás revertir esto!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Sí, eliminar servicio"),
            ),
          ],
        );
      },
    );

    if (confirmarEliminacion == true) {
      _eliminarProducto(context, producto);
    }
  }

  void _eliminarProducto(BuildContext context, ProductosModel producto) {
    productsDB!
      .eliminar(producto.idMobiliario!)
      .then((value) {
        if (value > 0) {
          AppValueNotifier.banProducts.value =
            !AppValueNotifier.banProducts.value;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Servicio eliminado"),
            ),
          );
        }
      });
  }

  void _showHistorial(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Historial'),
        content: SingleChildScrollView(
          child: Column(
            children: historial.map((item) {
              return ListTile(
                title: Text(item.cliente),
                subtitle: Text('Fecha: ${item.fecha}\nTipo de evento: ${item.tipoEvento}\nEstatus: ${item.estatus}'),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
            },
            child: Text('Cerrar'),
          ),
          ],
        );
      },
    );
  }
}




