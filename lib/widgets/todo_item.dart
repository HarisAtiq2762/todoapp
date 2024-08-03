import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../data/models/todo_model.dart';
import '../viewmodels/todo_viewmodel.dart';
import '../views/todo_details_view.dart:.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TodoDetailsView(todo: todo),
            ),
          );
        },
        child: Card(
          elevation: 8,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Hero(
                  tag: 'todo_${todo.id}_title',
                  child: Material(
                    color: Colors.transparent,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        todo.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          decoration:
                              todo.isDone ? TextDecoration.lineThrough : null,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Checkbox(
                  value: todo.isDone,
                  onChanged: (value) {
                    context
                        .read<TodoViewModel>()
                        .updateTodoStatus(todo.id!, value!);
                  },
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.trash, color: Colors.red),
                  onPressed: () {
                    context.read<TodoViewModel>().deleteTodo(todo.id!);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
