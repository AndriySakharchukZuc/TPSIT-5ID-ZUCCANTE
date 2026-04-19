import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'zadanko.db');
    return await openDatabase(
      path,
      version: 7,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        await _dropAll(db);
        await _onCreate(db, newVersion);
      },
    );
  }

  Future<void> _dropAll(Database db) async {
    final tables = [
      'users',
      'groups',
      'group_members',
      'tasks',
      'settings',
      'session',
    ];
    for (var table in tables) {
      await db.execute('DROP TABLE IF EXISTS $table');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE session (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');
  }

  Future<void> saveSession(String key, String value) async {
    final db = await database;
    final existing = await db.query(
      'session',
      where: '"key" = ?',
      whereArgs: [key],
    );
    if (existing.isNotEmpty) {
      await db.update(
        'session',
        {'value': value},
        where: '"key" = ?',
        whereArgs: [key],
      );
    } else {
      await db.insert('session', {'key': key, 'value': value});
    }
  }

  Future<String?> getSession(String key) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'session',
      where: '"key" = ?',
      whereArgs: [key],
    );
    if (maps.isEmpty) return null;
    return maps.first['value'] as String?;
  }

  Future<void> deleteSession(String key) async {
    final db = await database;
    await db.delete('session', where: '"key" = ?', whereArgs: [key]);
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete('session');
  }
}
