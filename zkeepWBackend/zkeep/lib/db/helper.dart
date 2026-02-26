import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/card.dart';
import '../models/task.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> _getDatabase() async {
    if (_database != null) return _database!;
    String path = join(await getDatabasesPath(), 'zkeep.db');
    _database = await openDatabase(path, version: 1, onCreate: _createTable);
    return _database!;
  }

  static Future<Database> init() async {
    return await _getDatabase();
  }

  static Future<void> _createTable(Database db, int version) async {
    await db.execute('''
    CREATE TABLE cards (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      server_id INTEGER,
      title TEXT
    );
    ''');

    await db.execute('''
    CREATE TABLE tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      server_id INTEGER,
      card_id INTEGER NOT NULL,
      server_card_id INTEGER,
      name TEXT,
      completed INTEGER,
      FOREIGN KEY (card_id) REFERENCES cards (id),
      FOREIGN KEY (server_card_id) REFERENCES cards (server_id)
    );
    ''');
  }

  static Future<List<CardModel>> getCards() async {
    Database db = await _getDatabase();
    final List<Map<String, dynamic>> result = await db.query('cards');

    if (result.isEmpty) {
      return <CardModel>[];
    }

    return result.map((row) => CardModel.fromMap(row)).toList();
  }

  static Future<int> insertCard(CardModel card) async {
    Database db = await _getDatabase();
    return await db.insert('cards', {
      'server_id': card.serverId,
      'title': card.title,
    });
  }

  static Future<void> updateCard(CardModel card) async {
    Database db = await _getDatabase();
    await db.update(
      'cards',
      card.toMap(),
      where: 'id = ?',
      whereArgs: [card.id],
    );
  }

  static Future<void> deleteCard(CardModel card) async {
    Database db = await _getDatabase();
    await db.delete('tasks', where: 'card_id = ?', whereArgs: [card.id]);
    await db.delete('cards', where: 'id = ?', whereArgs: [card.id]);
  }

  static Future<List<Task>> getTasks(int cardId) async {
    Database db = await _getDatabase();

    final List<Map<String, dynamic>> result = await db.query(
      'tasks',
      where: 'card_id = ?',
      whereArgs: [cardId],
    );

    if (result.isEmpty) {
      return <Task>[];
    }

    return result.map((row) {
      return Task.fromMap(row);
    }).toList();
  }

  static Future<int> insertTask(Task task) async {
    Database db = await _getDatabase();
    return await db.insert('tasks', task.toMap());
  }

  static Future<int> insertTaskFromSrv(Task task, int cardId) async {
    Database db = await _getDatabase();
    return await db.insert('tasks', {
      'server_id': task.serverId,
      'card_id': cardId,
      'server_card_id': task.serverCardId,
      'name': task.name,
      'completed': task.completed ? 1 : 0,
    });
  }

  static Future<void> updateTask(Task task) async {
    Database db = await _getDatabase();
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  static Future<void> deleteTask(Task task) async {
    Database db = await _getDatabase();
    await db.delete('tasks', where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<void> clearAllCards() async {
    Database db = await _getDatabase();
    await db.delete('tasks');
    await db.delete('cards');
  }
}
