import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseServices {
  DatabaseServices._();
  static final instance = DatabaseServices._();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  Future initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'ipotatotimer.db');
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      db.execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, description TEXT, duration TEXT)');
    });
  }

  addTask(Map<String, dynamic> model) async {
    final db = await database;
    model['id'] = Random().nextInt(900000) + 100000;
    var res = await db?.insert('tasks', model);
    return res;
  }

  tasks() async {
    final db = await database;
    return await db?.query('tasks');
  }
}
