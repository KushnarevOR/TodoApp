import 'package:lab1/TodoList.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TodoDB {
  static Database? database;

  Future<Database> initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, "todo_database.db");

    return await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE Todo (id INTEGER PRIMARY KEY, text TEXT NOT NULL, datetime TEXT, isDone INTEGER)');
      });
  }

  Future<Database?> get db async {
    if (database != null) {
      return database;
    }
    else{
      return await initDatabase();
    }
  }

  Future<int?> insert(Todo todo) async {
    var database = await db;
    todo.id = await database!.insert("Todo", todo.toMap());
    return todo.id;
  }

  Future<Todo> getTodo(int? id) async {
    var database = await db;
    var result = await database!.rawQuery('SELECT * FROM Todo WHERE id = $id');
    return Todo.fromMap(result.first);
  }

  Future<List> getAllTodo() async {
    var database = await db;
    var result = await database!.rawQuery('SELECT * FROM Todo');
    return result.toList();
  }

  Future<int> delete(int id) async {
    var database = await db;
    return await database!.delete("Todo", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Todo todo) async {
    var database = await db;
    return await database!.update("Todo", todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id]);
  }

  Future close() async => database!.close();
}