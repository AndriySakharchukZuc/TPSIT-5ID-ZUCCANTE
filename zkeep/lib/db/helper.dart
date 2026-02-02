import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/card.dart';
import '../models/task.dart';

class DatabaseHelper {
  static Future<Database> init() async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  static Future<void> _createTable(Database db, int version) async {
    await db.execute('''
    CREATE TABLE cards (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT
    );
    ''');

    await db.execute('''
    CREATE TABLE tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      cardId INTEGER NOT NULL,
      name TEXT NOT NULL,
      completed INTEGER NOT NULL,
      FOREIGN KEY (cardId) REFERENCES cards (id)
    );
    ''');
  }

  static Future<List<CardModel>> getCards() async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);
    final List<Map<String, dynamic>> result = await db.query('cards');

    if (result.isEmpty) {
      return <CardModel>[];
    }

    return result.map((row) => CardModel.fromMap(row)).toList();
  }

  static Future<void> insertCard(CardModel card) async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);
    await db.insert('cards', card.toMap());
  }

  static Future<void> updateCard(CardModel card) async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);
    await db.update('cards', card.toMap(), where: 'id = ?', whereArgs: [card.id]);
  }

  static Future<void> deleteCard(CardModel card) async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);
    await db.delete('cards', where: 'id = ?', whereArgs: [card.id]);
  }

  static Future<List<Task>> getTasks(int cardId) async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);
    final List<Map<String, dynamic>> result = await db.query('tasks', where: 'cardId = ?', whereArgs: [cardId]);

    if (result.isEmpty) {
      return <Task>[];
    }

    return result.map((row) => Task.fromMap(row)).toList();
  }

  static Future<void> insertTask(Task task) async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);
    await db.insert('tasks', task.toMap());
  }

  static Future<void> updateTask(Task task) async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);
    await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<void> deleteTask(Task task) async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);
    await db.delete('tasks', where: 'id = ?', whereArgs: [task.id]);
  }
}