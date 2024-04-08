import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mobiliarios/model/mobiliario_model.dart';

class ProductsDatabase {
  static final String NAMEDB = 'RENTAMOBILIARIODB';
  static final int VERSIONDB = 1;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    return _database = await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String pathDB = join(folder.path, NAMEDB);
    return openDatabase(
      pathDB,
      version: VERSIONDB,
      onCreate: (db, version) {
        String query = '''CREATE TABLE tblMobiliario(
          idMobiliario INTEGER PRIMARY KEY,
          nombreCliente VARCHAR(100),
          fechaEntrega VARCHAR(10),
          telefono1 VARCHAR(20),
          telefono2 VARCHAR(20),
          tipoEvento VARCHAR(50),
          estado VARCHAR(20),
          cantidadSillas INTEGER,
          cantidadMesas INTEGER,
          cantidadManteles INTEGER,
          cantidadToldos INTEGER
        )''';
        db.execute(query);
      },
    );
  }

  Future<int> insertar(Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion.insert('tblMobiliario', data);
  }

  Future<int> actualizar(Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion.update(
      'tblMobiliario',
      data,
      where: 'idMobiliario = ?',
      whereArgs: [data['idMobiliario']],
    );
  }

  Future<int> eliminar(int idMobiliario) async {
    var conexion = await database;
    return conexion.delete(
      'tblMobiliario',
      where: 'idMobiliario = ?',
      whereArgs: [idMobiliario],
    );
  }

  Future<List<ProductosModel>> consultar() async {
    var conexion = await database;
    var products = await conexion.query('tblMobiliario');
    return products.map((product) => ProductosModel.fromMap(product)).toList();
  }
}


