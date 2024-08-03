import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../data/models/todo_model.dart';

class TodoDetailsView extends StatelessWidget {
  final Todo todo;

  TodoDetailsView({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'todo_${todo.id}_title',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  todo.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.description),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    todo.description,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 10),
                Text(
                  'Due Date: ${DateFormat.yMd().format(todo.dueDate)}',
                  style: const TextStyle(
                      fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(todo.isDone
                    ? FontAwesomeIcons.checkCircle
                    : FontAwesomeIcons.timesCircle),
                const SizedBox(width: 10),
                Text(
                  'Status: ${todo.isDone ? 'Completed' : 'Pending'}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
