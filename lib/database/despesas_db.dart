import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '/models/despesa_model.dart';

class DespesaDB {
  static final DespesaDB instance = DespesaDB._init();
  static Database? _database;

  DespesaDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('relatorios.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE relatorios (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      titulo TEXT NOT NULL,
      valor REAL NOT NULL,
      data TEXT NOT NULL,
      time_id INTEGER NOT NULL
    )
  ''');
  }

  Future<int> inserirRelatorio(Despesa relatorio) async {
    final db = await instance.database;
    return await db.insert('relatorios', relatorio.toMap());
  }

  Future<List<Despesa>> listarRelatorios(int timeId) async {
    final db = await instance.database;
    final result = await db.query(
      'relatorios',
      where: 'time_id = ?',
      whereArgs: [timeId],
      orderBy: 'id DESC',
    );
    return result.map((e) => Despesa.fromMap(e)).toList();
  }

  Future<int> deletarRelatorio(int id) async {
    final db = await instance.database;
    return await db.delete('relatorios', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> fechar() async {
    final db = await instance.database;
    db.close();
  }
}
