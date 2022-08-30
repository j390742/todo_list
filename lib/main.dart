import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/services/sqlite_datasource.dart';
import 'package:todo_list/services/todo_datasource.dart';
import 'package:todo_list/widgets/todo_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.I.registerSingleton<TodoDatasource>(
    LocalSQLiteDataSource(),
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => TodoList(),
      child: const TodoApp(),
    ),
  );
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color.fromARGB(255, 217, 39, 46),
        errorColor: const Color.fromARGB(255, 220, 53, 69),
        fontFamily: 'Georga',
      ),
      home: const TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({Key? key}) : super(key: key);

  @override
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final TextEditingController _controlName = TextEditingController();
  final TextEditingController _controlDescription = TextEditingController();

  final Color primary = const Color.fromARGB(255, 217, 39, 46);

  final List<Color?> listBackground = [Colors.grey[300], Colors.grey[380]];

  TodoList listTodo = TodoList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<TodoList>(
          builder: (context, value, child) {
            listTodo = value;
            return RefreshIndicator(
              onRefresh: listTodo.refresh,
              child: ListView.builder(
                itemCount: listTodo.toDoCount,
                itemBuilder: (BuildContext context, int i) {
                  return TodoWidget(
                      todo: listTodo.todos[i],
                      backgroundColour: listBackground[i % 2]);
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTodo,
        tooltip: "Add list item",
        child: const Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        title: Consumer<TodoList>(
          builder: (context, value, child) {
            TodoList smallList = value;
            return Text(
                "Completed count: ${(smallList.todos.where((element) => element.complete)).length}");
          },
        ),
        backgroundColor: primary,
        foregroundColor: const Color.fromARGB(255, 248, 249, 250),
      ),
    );
  }

  _openAddTodo() {
    showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(4),
                  child: Text("Title"),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: TextFormField(
                    controller: _controlName,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(4),
                  child: Text("Content"),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: TextFormField(
                    controller: _controlDescription,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(
                        () {
                          listTodo.add(Todo(
                            name: _controlName.text,
                            description: _controlDescription.text,
                          ));
                          _controlName.clear();
                          _controlDescription.clear();
                          Navigator.pop(context);
                        },
                      );
                    },
                    child: const Text("Submit"),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
