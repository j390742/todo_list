import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_list/services/todo_datasource.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  late int id;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late String description;
  @HiveField(3)
  late bool complete;

  Todo(
      {this.id = 0,
      required this.name,
      required this.description,
      this.complete = false});

  factory Todo.fromJson(Map<String, dynamic> json) {
    //Note: ID isn't passed through. FIx later
    return Todo(
        id: json['_id'],
        name: json['name'] ?? "",
        description: json['description'] ?? "",
        complete: json['completed'] ?? false);
  }

  Map<String, dynamic> toJSON() {
    return {'name': name, 'description': description, 'completed': complete};
  }

  @override
  String toString() {
    return "$name - ($description)";
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'complete': complete ? 1 : 0
    };
  }
}

class TodoAdapter extends TypeAdapter<Todo> {
  @override
  Todo read(BinaryReader reader) {
    return Todo(
        id: reader.read(0) ?? 0,
        name: reader.read(1) ?? "",
        description: reader.read(2) ?? "",
        complete: reader.read(3) ?? false);
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, Todo obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.description);
    writer.write(obj.complete);
  }
}

class TodoList extends ChangeNotifier {
  late List<Todo> _todos = [];
  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);
  int get toDoCount => _todos.length;

  Future<void> add(Todo todo) async {
    _todos.add(todo);

    await GetIt.I<TodoDatasource>().addTodo(todo);
    notifyListeners();
  }

  Future<void> removeAll() async {
    _todos.clear();

    await GetIt.I<TodoDatasource>().deleteAllTodo();
    notifyListeners();
  }

  Future<void> remove(Todo todo) async {
    _todos.removeWhere((element) => element == todo);

    await GetIt.I<TodoDatasource>().deleteTodo(todo);
    notifyListeners();
  }

  Future<void> updateTodo(Todo todo) async {
    Todo listTodo;
    listTodo = _todos.firstWhere((t) => t.name == todo.name);
    listTodo = todo;

    await GetIt.I<TodoDatasource>().updateTodo(todo);
    notifyListeners();
  }

  Future<void> refresh() async {
    _todos = await GetIt.I<TodoDatasource>().all();
    notifyListeners();
  }
}
