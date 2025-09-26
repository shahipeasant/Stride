class Todo {
  final String id;
  final String title;
  final bool done;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.title,
    required this.done,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'done': done,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Todo.fromMap(String id, Map<String, dynamic> map) {
    return Todo(
      id: id,
      title: map['title'] ?? '',
      done: map['done'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
