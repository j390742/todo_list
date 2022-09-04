import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_list/services/todo_datasource.dart';

class Todo {
  late int id;
  late String name;
  late String description;
  late bool complete;

  Todo(
      {int id = 0,
      bool complete = false,
      required String name,
      required String description}) {
    this.id = id;
    this.name = name;
    this.description = description;
    this.complete = complete;
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
