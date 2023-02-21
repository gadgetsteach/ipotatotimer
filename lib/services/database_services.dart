// import 'package:path/path.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:uuid/uuid.dart';

class DatabaseServices {
  DatabaseServices._();
  static final instance = DatabaseServices._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'ipotatotimer');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY UNIQUE, title TEXT, description TEXT, duration TEXT)');
    });
  }

  addTask(Map<String, dynamic> model) async {
    // var uuid = const Uuid();
    final db = await database;
    model['id'] = 21313;

    var raw = await db.rawInsert(
        "INSERT Into tasks(id,title,description,duration)"
        "VALUES(${model['id']}, ${model['title']}, ${model['description']}, 'hey'})",
        [model['id'], model['title'], model['description'], 'hey']);
    return raw;
    // db.insert('tasks', model).then((value) {
    //   if (kDebugMode) {
    //     print(value);
    //   }
    // });
  }

  tasks() async {
    final db = await database;
    return db.rawQuery('SELECT * FROM tasks');
  }
}
