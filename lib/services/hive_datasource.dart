import '../models/todo.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/services/todo_datasource.dart';

class LocalHiveDataSource implements TodoDatasource {
  LocalHiveDataSource() {
    init();
  }

  late Box box;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TodoAdapter());
    box = await Hive.openBox('todos_box');

    //Test value and add test
    TodoList tdl = TodoList();
    tdl.add(Todo(name: "yes", description: "mon"));
    tdl.add(Todo(name: "no", description: "wed"));

    await box.put('list', tdl);
  }

  @override
  Future<List<Todo>> all() {
    return box.get('list');
  }

  @override
  Future<bool> addTodo(Todo t) {
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteAllTodo() {
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteTodo(Todo t) {
    throw UnimplementedError();
  }

  @override
  Future<Todo> getTodo(int id) {
    return box.get('list')[id];
  }

  @override
  Future<bool> updateTodo(Todo t) {
    throw UnimplementedError();
  }
}
