import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolistapp/models/task.dart';

class DatabaseHelper {
  static Future<Database> init() async {
    // get path
    String path = join(await getDatabasesPath(), 'tasks.db');

    // open/create the database
    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  static Future<void> _createTable(Database db, int version) async {
    // bool -> INTEGER
    return await db.execute('''
    CREATE TABLE tasks (
      id INTEGER NOT NULL PRIMARY KEY,
      name TEXT NOT NULL,
      checked INTEGER NOT NULL 
    );
    ''');
  }

  static Future<List<Task>> getTodos() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    Database db = await openDatabase(path, version: 1);
    /*
    final List<Map<String, dynamic>> result = await db.rawQuery(
       'SELECT * FROM todos',
    );
    */
    final List<Map<String, dynamic>> result = await db.query('tasks');
    if (result.isEmpty) {
      return <Task>[];
    }
    // db.close();
    return result.map((row) => Task.fromMap(row)).toList();
  }

  static Future<void> insertTodo(Task task) async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    Database db = await openDatabase(path, version: 1);
    // db.rawInsert('INSERT INTO todos(name, checked) values (?, ?)', [todo.name, todo.checked ? 1 : 0]);
    db.insert('tasks', task.toMap());
    // db.close();
  }

  static Future<void> updateTodo(Task task) async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    Database db = await openDatabase(path, version: 1);
    // do not check existence!
    // db.rawUpdate('UPDATE todos SET value = ? WHERE id = ?', [todo.checked ? 0 : 1, todo.id]);
    db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
    // db.close();
  }

  static Future<void> deleteTodo(Task task) async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    Database db = await openDatabase(path, version: 1);
    db.delete('tasks', where: 'id = ?', whereArgs: [task.id]);
    // db.close();
  }

  Future<int> deleteAll() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    Database db = await openDatabase(path, version: 1);
    return await db.delete('tasks');
  }
}
