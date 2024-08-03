import '../database/database_provider.dart';
import '../models/todo_model.dart';

class TodoRepository {
  final DatabaseProvider databaseProvider;

  TodoRepository({required this.databaseProvider});

  Future<List<Todo>> loadTodos() async {
    return await databaseProvider.readAllTodos();
  }

  Future<Todo> addTodo(Todo todo) async {
    return await databaseProvider.create(todo);
  }

  Future<int> updateTodo(Todo todo) async {
    return await databaseProvider.update(todo);
  }

  Future<int> deleteTodo(int id) async {
    return await databaseProvider.delete(id);
  }
}
