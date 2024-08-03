import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/todo_model.dart';
import '../data/repositories/todo_repository.dart';

// ViewModel class
class TodoViewModel extends Cubit<TodoState> {
  final TodoRepository todoRepository;

  TodoViewModel({required this.todoRepository}) : super(TodoLoading()) {
    loadTodos();
  }

  Future<void> loadTodos() async {
    try {
      final todos = await todoRepository.loadTodos();
      emit(TodoLoaded(todos));
    } catch (_) {
      emit(TodoError('Failed to load todos'));
    }
  }

  Future<void> addTodo(
      String title, String description, DateTime dueDate) async {
    if (state is TodoLoaded) {
      final currentState = state as TodoLoaded;
      try {
        final newTodo = Todo(
          title: title,
          description: description,
          dueDate: dueDate,
          isDone: false,
        );
        final savedTodo = await todoRepository.addTodo(newTodo);
        final updatedTodos = List<Todo>.from(currentState.todos)
          ..add(savedTodo);
        emit(TodoLoaded(updatedTodos));
      } catch (_) {
        emit(TodoError('Failed to add todo'));
      }
    }
  }

  Future<void> updateTodoStatus(int id, bool isDone) async {
    if (state is TodoLoaded) {
      final currentState = state as TodoLoaded;
      try {
        final updatedTodo = currentState.todos
            .firstWhere((todo) => todo.id == id)
            .copy(isDone: isDone);
        await todoRepository.updateTodo(updatedTodo);
        final updatedTodos = currentState.todos
            .map((todo) => todo.id == id ? updatedTodo : todo)
            .toList();
        emit(TodoLoaded(updatedTodos));
      } catch (_) {
        emit(TodoError('Failed to update todo'));
      }
    }
  }

  Future<void> deleteTodo(int id) async {
    if (state is TodoLoaded) {
      final currentState = state as TodoLoaded;
      try {
        await todoRepository.deleteTodo(id);
        final updatedTodos =
            currentState.todos.where((todo) => todo.id != id).toList();
        emit(TodoLoaded(updatedTodos));
      } catch (_) {
        emit(TodoError('Failed to delete todo'));
      }
    }
  }
}

// State classes
abstract class TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Todo> todos;

  TodoLoaded(this.todos);
}

class TodoError extends TodoState {
  final String error;

  TodoError(this.error);
}
