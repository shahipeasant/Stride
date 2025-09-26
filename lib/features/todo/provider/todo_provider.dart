import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../model/todo_model.dart';
import '../repository/todo_repository.dart';

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return TodoRepository();
});

final todoNotifierProvider =
StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  final repo = ref.watch(todoRepositoryProvider);
  return TodoNotifier(repo);
});

class TodoNotifier extends StateNotifier<List<Todo>> {
  final TodoRepository _repository;
  String? _uid;

  TodoNotifier(this._repository) : super([]);

  void setUid(String uid) {
    _uid = uid;
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    if (_uid == null) return;
    final todos = await _repository.fetchTodos(_uid!);
    state = todos;
  }

  Future<void> addTodo(Todo todo) async {
    if (_uid == null) return;
    await _repository.addTodo(_uid!, todo);
    fetchTodos();
  }

  Future<void> toggleDone(String id, bool newValue) async {
    if (_uid == null) return;
    await _repository.toggleDone(_uid!, id, newValue);
    fetchTodos();
  }

  Future<void> deleteTodo(String id) async {
    if (_uid == null) return;
    await _repository.deleteTodo(_uid!, id);
    fetchTodos();
  }
}