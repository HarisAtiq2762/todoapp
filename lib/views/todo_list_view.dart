import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/todo_model.dart';
import '../viewmodels/todo_viewmodel.dart';
import '../widgets/todo_item.dart';
import 'add_todo_view.dart';

class TodoListView extends StatefulWidget {
  const TodoListView({super.key});

  @override
  _TodoListViewState createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  List<Todo> _todos = [];
  List<Todo> _filteredTodos = [];
  String _searchQuery = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadTodos();
  }

  void _loadTodos() async {
    await Future.delayed(Duration.zero); // Wait for the first frame to render
    final state = context.read<TodoViewModel>().state;
    if (state is TodoLoaded) {
      setState(() {
        _todos = List.from(state.todos);
        _filteredTodos = List.from(_todos);
      });
    }
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _filterTodos();
    });
  }

  void _filterTodos() {
    setState(() {
      _filteredTodos = _todos
          .where((todo) =>
              todo.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              todo.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) => _updateSearchQuery(query),
            ),
          ),
          BlocConsumer<TodoViewModel, TodoState>(
            listener: (context, state) {
              if (state is TodoLoaded) {
                _updateList(state.todos);
              }
            },
            builder: (context, state) {
              if (state is TodoLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TodoLoaded) {
                if (_filteredTodos.isEmpty) {
                  return const Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.list_alt, size: 80, color: Colors.grey),
                          SizedBox(height: 20),
                          Text(
                            'Your todo list is empty',
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: _filteredTodos.length,
                    itemBuilder: (context, index) {
                      return TodoItem(todo: _filteredTodos[index]);
                    },
                  ),
                );
              } else if (state is TodoError) {
                return Center(child: Text(state.error));
              }
              return Container();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddTodoView(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _updateList(List<Todo> todos) {
    setState(() {
      _todos = List.from(todos);
      _filterTodos();
    });
  }
}
