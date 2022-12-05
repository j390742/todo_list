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
    // initialise database connection
    await initTask;
    // Get the databse items to be location
    final DatabaseReference ref = await database.ref('todos/${t.id}');

    // Set the stored data to the data ref
    ref.set(t.toJSON());

    // Get the item back
    final DataSnapshot snapshot = await ref.child("todos/${t.id}").get();

    // Return if it was successful or not
    return snapshot.exists;
  }

  @override
  Future<bool> deleteAllTodo() async {
    //maybe not the best idea to implement a delete it all for a remote database
    return false;
  }

  @override
  Future<bool> deleteTodo(Todo t) async {
    // almost exactly the same as Add, just with remove instead of set
    // initialise database connection
    await initTask;
    // Get the databse items to be location
    final DatabaseReference ref = await database.ref('todos/${t.id}');

    // Remove the stored data to the data ref
    ref.remove();

    // Get the item back
    final DataSnapshot snapshot = await ref.child("todos/${t.id}").get();

    // Return if it was successful or not
    return !snapshot.exists;
  }

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
    // almost exactly the same as Delete, just with update instead of remove
    // initialise database connection
    await initTask;
    // Get the databse items to be location
    final DatabaseReference ref = await database.ref('todos/${t.id}');

    // Update the stored data to the data ref
    ref.update(t.toJSON());

    // Get the item back
    final DataSnapshot snapshot = await ref.child("todos/${t.id}").get();

    // Return if it was successful or not
    return snapshot.exists;
  }
} /*snapshot.children.map<Todo>((e) => Todo.fromJson(e.value as Map<String, dynamic>)); */
