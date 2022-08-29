import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/todo.dart';
import 'package:todo_list/services/todo_datasource.dart';

class LocalSQLiteDataSource implements TodoDatasource {
  late Database database;
  bool initialised = false;
  
  LocalSQLiteDataSource(){
    init();
  }

  Future<void> init() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'todo_data.db'), 
      onCreate: (db, version) {
        return db.execute('CREATE TABLE IF NOT EXISTS todos (id INTEGER PRIMARY KEY, name TEXT, description TEXT, complete INTEGER)');
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
  Future<bool> addTodo(Todo t){
    Map<String, dynamic> map = t.toMap();
    map.remove('id');
    Future<int> id = database.insert('todos', map, conflictAlgorithm: ConflictAlgorithm.replace);
    //t.id = id;
  }

  @override
  Future<bool> deleteTodo(Todo t){
    if (t.id == 0 || !initialised)

    database.delete('todos', where:'id= ?', whereArgs: [t.id]);
  }

  @override
  Future<Todo> getTodo(int id){

  }

  @override
  Future<bool> updateTodo(Todo t){

  }
}