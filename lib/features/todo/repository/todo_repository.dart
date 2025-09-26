import 'package:firebase_database/firebase_database.dart';

import '../model/todo_model.dart';

class TodoRepository {
  final _db = FirebaseDatabase.instance.ref();

  Future<List<Todo>> fetchTodos(String uid) async {
    final snapshot = await _db.child('users/$uid/todos').get();

    if (snapshot.exists && snapshot.value is Map) {
      final raw = snapshot.value as Map<Object?, Object?>;

      final todos = raw.entries.map((entry) {
        final data = Map<String, dynamic>.from(entry.value as Map);
        return Todo.fromMap(entry.key as String, data);
      }).toList();

      // Sort by createdAt (most recent first, or oldest first depending on preference)
      todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return todos;
    } else {
      return [];
    }
  }

  Future<void> addTodo(String uid, Todo todo) async {
    final newRef = _db.child('users/$uid/todos').push();
    await newRef.set(todo.toMap());
  }

  Future<void> toggleDone(String uid, String todoId, bool newValue) async {
    await _db.child('users/$uid/todos/$todoId').update({'done': newValue});
  }

  Future<void> deleteTodo(String uid, String todoId) async {
    await _db.child('users/$uid/todos/$todoId').remove();
  }
}