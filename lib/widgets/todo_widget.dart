import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/todo.dart';

class TodoWidget extends StatefulWidget {
  final Todo todo;
  final Color? backgroundColour;
  const TodoWidget({
    Key? key,
    required this.todo,
    required this.backgroundColour,
  }) : super(key: key);

  @override
  TodoWidgetState createState() => TodoWidgetState();
}

class TodoWidgetState extends State<TodoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: widget.backgroundColour),
      child: Container(
        padding: const EdgeInsets.all(7),
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 217, 39, 46),
            width: 1.3,
          ),
        ),
        child: Row(
          children: [
            Checkbox(
                value: widget.todo.complete,
                onChanged: (bool? state) {
                  setState(() {
                    widget.todo.complete = state!;
                    Provider.of<TodoList>(context, listen: false)
                        .updateTodo(widget.todo);
                  });
                }),
            Text(
              ": ${widget.todo.toString()}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
