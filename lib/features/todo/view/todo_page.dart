import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/todo_provider.dart';
import 'add_todo_dialog.dart';

class TodoPage extends ConsumerStatefulWidget {
  const TodoPage({super.key});

  @override
  ConsumerState<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends ConsumerState<TodoPage> {
  @override
  void initState() {
    super.initState();
    // Set current user UID for the notifier
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      ref.read(todoNotifierProvider.notifier).setUid(uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todoNotifierProvider);

    return Scaffold(
      body: todos.isEmpty
          ? const Center(child: Text("No todos for today"))
          : ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return Card(
            child: CheckboxListTile(
              title: Text(todo.title),
              value: todo.done,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(todoNotifierProvider.notifier)
                      .toggleDone(todo.id, value);
                }
              },
              secondary: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  ref
                      .read(todoNotifierProvider.notifier)
                      .deleteTodo(todo.id);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const AddTodoDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
