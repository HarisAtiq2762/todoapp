import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/todo_model.dart';

class DatabaseProvider {
  static final DatabaseProvider instance = DatabaseProvider._init();
  static Database? _database;

  DatabaseProvider._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path,
        version: 2, onCreate: _createDB, onUpgrade: _upgradeDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const dateType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';

    await db.execute('''
    CREATE TABLE $tableTodos (
      ${TodoFields.id} $idType,
      ${TodoFields.title} $textType,
      ${TodoFields.description} $textType,
      ${TodoFields.dueDate} $dateType,
      ${TodoFields.isDone} $boolType
    )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      ALTER TABLE $tableTodos ADD COLUMN ${TodoFields.description} TEXT NOT NULL DEFAULT ''
      ''');
    }
  }

  Future<Todo> create(Todo todo) async {
    final db = await instance.database;
    final id = await db.insert(tableTodos, todo.toJson());
    return todo.copy(id: id);
  }

  Future<Todo> readTodo(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableTodos,
      columns: TodoFields.values,
      where: '${TodoFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Todo.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Todo>> readAllTodos() async {
    try {
      final db = await instance.database;
      const orderBy = '${TodoFields.id} ASC';
      final result = await db.query(tableTodos, orderBy: orderBy);
      return result.map((json) => Todo.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<int> update(Todo todo) async {
    final db = await instance.database;
    return db.update(
      tableTodos,
      todo.toJson(),
      where: '${TodoFields.id} = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return db.delete(
      tableTodos,
      where: '${TodoFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

const String tableTodos = 'todos';

class TodoFields {
  static final List<String> values = [id, title, description, dueDate, isDone];

  static const String id = '_id';
  static const String title = 'title';
  static const String description = 'description';
  static const String dueDate = 'dueDate';
  static const String isDone = 'isDone';
}
