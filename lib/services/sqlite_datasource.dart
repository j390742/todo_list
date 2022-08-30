import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/todo.dart';
import 'package:todo_list/services/todo_datasource.dart';

class LocalSQLiteDataSource implements TodoDatasource {
  late Database database;
  bool initialised = false;

  LocalSQLiteDataSource() {
    init();
  }

  Future<void> init() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'todo_data.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE IF NOT EXISTS todos (id INTEGER PRIMARY KEY, name TEXT, description TEXT, complete INTEGER)');
      },
    );
    initialised = true;
  }

  //CRUD
  @override
  Future<List<Todo>> all() async {
    if (!initialised) return <Todo>[];
    List<Map<String, dynamic>> maps = await database.query('todos');
    return List.generate(maps.length, (index) {
      return Todo(
          id: maps[index]['id'],
          name: maps[index]['name'],
          description: maps[index]['description'],
          complete: maps[index]['complete'] != 0);
    });
  }

  @override
  Future<bool> addTodo(Todo t) async {
    if (initialised) {
      Map<String, dynamic> map = t.toMap();
      map.remove('id');
      t.id = await database.insert('todos', map,
          conflictAlgorithm: ConflictAlgorithm.replace);
      return true;
    }
    return false;
  }

  @override
  Future<bool> deleteTodo(Todo t) async {
    if (initialised) {
      database.delete('todos', where: 'id= ?', whereArgs: [t.id]);
      return true;
    }
    return false;
  }

  @override
  Future<Todo> getTodo(int id) async {
    if (initialised) {
      List<Map<String, dynamic>> map = await database.query("todos",
          where: 'id= ?', whereArgs: [id], limit: 1);

      return Todo(
          id: map[0]['id'],
          name: map[0]['name'],
          description: map[0]['description'],
          complete: map[0]['complete'] != 0);
    }
    return Todo(name: "", description: "");
  }

  @override
  Future<bool> updateTodo(Todo t) async {
    if (initialised) {
      database.update('todos', t.toMap(),
          where: "id = ?",
          whereArgs: [t.id],
          conflictAlgorithm: ConflictAlgorithm.replace);
      return true;
    }
    return false;
  }
}
