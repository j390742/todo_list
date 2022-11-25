import '../models/todo.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/services/todo_datasource.dart';

class LocalHiveDataSource implements TodoDatasource {
  late Future initData;

  LocalHiveDataSource() {
    initData = Future(init);
  }

  late Box box;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TodoAdapter());
    //Hive.deleteBoxFromDisk('todos_box');
    box = await Hive.openBox('todos_box');

    //Test value and add test
    /*
    List<Todo> tdl = List.empty(growable: true);
    tdl.add(Todo(name: "yes", description: "mon", id: 0));
    tdl.add(Todo(name: "no", description: "wed", id: 1));

    await box.put('list', tdl);
    */
  }

  @override
  Future<List<Todo>> all() async {
    await initData;
    return box.get('list');
  }

  @override
  Future<bool> addTodo(Todo t) async {
    await initData;
    // get the list currently
    List<dynamic> all = box.get('list', defaultValue: []);

    // add the new item
    all.add(t);

    // put the list back
    box.put('list', all);

    // return if t is in the list stored
    return box.get('list')[t.id] == t;
  }

  @override
  Future<bool> deleteAllTodo() async {
    await initData;
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteTodo(Todo t) async {
    await initData;
    throw UnimplementedError();
  }

  @override
  Future<Todo> getTodo(int id) async {
    await initData;
    return box.get('list')[id];
  }

  @override
  Future<bool> updateTodo(Todo t) async {
    await initData;
    // get the list currently
    List<dynamic> all = box.get('list', defaultValue: []);

    // update the new item
    all[t.id] = t;

    // put the list back
    box.put('list', all);

    // return if t is in the list stored
    return box.get('list')[t.id] == t;
  }
}
