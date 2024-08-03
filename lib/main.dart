import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/database/database_provider.dart';
import 'data/repositories/todo_repository.dart';
import 'viewmodels/todo_viewmodel.dart';
import 'views/todo_list_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final TodoRepository todoRepository =
      TodoRepository(databaseProvider: DatabaseProvider.instance);

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoViewModel(todoRepository: todoRepository),
      child: MaterialApp(
        title: 'Todo List App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TodoListView(),
      ),
    );
  }
}
