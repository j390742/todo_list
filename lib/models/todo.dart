import 'dart:collection';

import 'package:flutter/widgets.dart';

class Todo {
  late int id;
  late String name;
  late String description;
  late bool complete;

  Todo({int id = 0, bool complete = false, required String name, required String description}) {
    this.id = id;
    this.name = name;
    this.description = description;
    this.complete = complete;
  }

  @override
  String toString() {
    return "$name - ($description)";
  }


  Map<String, dynamic> toMap(){
    return{
      'id' : id,
      'name' : name,
      'description' : description,
      'complete' : complete ? 1 : 0
    };
  }
}

class TodoList extends ChangeNotifier {
  final List<Todo> _todos = [];
  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);
  int get toDoCount => _todos.length;

  void add(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void removeAll() {
    _todos.clear();
    notifyListeners();
  }

  void remove(Todo todo) {
    _todos.removeWhere((element) => element == todo);
    notifyListeners();
  }

  void updateTodo(Todo todo) {
    Todo listTodo;
    listTodo = _todos.firstWhere((t) => t.name == todo.name);
    listTodo = todo;
    notifyListeners();
  }
}