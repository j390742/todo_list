import 'dart:ffi';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:todo_list/firebase_options.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/services/todo_datasource.dart';

class RemoteAPIDataSource extends TodoDatasource {
  late FirebaseDatabase database;
  late Future initTask;

  RemoteAPIDataSource() {
    initTask = Future(() async {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      database = FirebaseDatabase.instance;
    });
  }

  @override
  Future<List<Todo>> all() async {
    await initTask;
    List<Todo> todos = <Todo>[];

    //get the todos
    final DataSnapshot snapshot = await database.ref("todos").get();
    //if successful
    if (snapshot.exists) {
      //get the objects as todos from json

      (snapshot.value as Map<String, dynamic>).forEach((key, value) {
        //Get the ID
        value['_id'] = key;
        //give it all to a TODO_obj
        todos.add(Todo.fromJson(value));
      });

      //Return the complete list
      return todos;
    } else {
      //if there isn't a snapshot. Return exception
      throw Exception(
          "Invalid Request - Missing Snapshot: ${snapshot.ref.path}");
    }
  }

  @override
  Future<bool> addTodo(Todo t) async {
    await initTask;
  }

  @override
  Future<bool> deleteAllTodo() async {}

  @override
  Future<bool> deleteTodo(Todo t) async {}

  @override
  Future<Todo> getTodo(int id) async {
    await initTask;
    Todo todo = Todo(name: "", description: "");

    //get the specific todo from the snapshot
    final DatabaseReference ref = await database.ref();
    final DataSnapshot snapshot = await ref.child("todos/$id").get();

    //check the snapshot for problems (like not existing)
    if (snapshot.exists) {
      //get the objects as todos from json

      //copied from earlier code for simplicities sake
      (snapshot.value as Map<String, dynamic>).forEach((key, value) {
        //Get the ID
        value['_id'] = key;
        //give it all to a TODO_obj
        todo = Todo.fromJson(value);
      });

      return todo;
    } else {
      //if there isn't a snapshot. Return exception
      throw Exception(
          "Invalid Request - Missing Snapshot: ${snapshot.ref.path}");
    }
  }

  @override
  Future<bool> updateTodo(Todo t) async {
    //get the specific todo
    final DatabaseReference ref = await database.ref("todos/${t.id}");
  }
} /*snapshot.children.map<Todo>((e) => Todo.fromJson(e.value as Map<String, dynamic>)); */
