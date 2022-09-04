import '../models/todo.dart';

abstract class TodoDatasource {
  Future<List<Todo>> all();
  Future<bool> addTodo(Todo t);
  Future<bool> deleteAllTodo();
  Future<bool> deleteTodo(Todo t);
  Future<Todo> getTodo(int id);
  Future<bool> updateTodo(Todo t);
}
