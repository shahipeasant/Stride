class DailyLog {
  final String id;
  final DateTime date;
  final int completedTodos;
  final int totalTodos;
  final int rating; // can be derived from completion
  final String emoji;
  final DateTime createdAt;

  DailyLog({
    required this.id,
    required this.date,
    required this.completedTodos,
    required this.totalTodos,
    required this.rating,
    required this.emoji,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'completedTodos': completedTodos,
      'totalTodos': totalTodos,
      'rating': rating,
      'emoji': emoji,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory DailyLog.fromMap(String id, Map<String, dynamic> map) {
    return DailyLog(
      id: id,
      date: DateTime.parse(map['date']),
      completedTodos: map['completedTodos'] ?? 0,
      totalTodos: map['totalTodos'] ?? 0,
      rating: map['rating'] ?? 0,
      emoji: map['emoji'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
