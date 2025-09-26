import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../todo/model/todo_model.dart';
import '../model/daily_log.dart';
import '../repository/daily_log_repository.dart';

final dailyLogRepositoryProvider = Provider<DailyLogRepository>((ref) {
  return DailyLogRepository();
});

final dailyLogNotifierProvider =
StateNotifierProvider<DailyLogNotifier, List<DailyLog>>((ref) {
  final repo = ref.watch(dailyLogRepositoryProvider);
  return DailyLogNotifier(repo);
});

class DailyLogNotifier extends StateNotifier<List<DailyLog>> {
  final DailyLogRepository _repo;
  String? _uid;

  DailyLogNotifier(this._repo) : super([]);

  void setUid(String uid) {
    _uid = uid;
    fetchLogs();
  }

  Future<void> fetchLogs() async {
    if (_uid == null) return;
    final logs = await _repo.fetchLogs(_uid!);
    state = logs;
  }

  Future<void> addLog(DailyLog log) async {
    if (_uid == null) return;
    await _repo.addLog(_uid!, log);
    fetchLogs();
  }

  Future<void> updateLog(DailyLog log) async {
    if (_uid == null) return;
    await _repo.updateLog(_uid!, log);
    fetchLogs();
  }

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> updateTodayLog(List<Todo> todos) async {
    if (_uid == null) return;

    final today = DateTime.now();
    final completed = todos.where((t) => t.done).length;
    final total = todos.length;
    final rating = total == 0 ? 0 : ((completed / total) * 5).round();
    final emoji = rating >= 4
        ? '😎'
        : rating >= 2
        ? '🙂'
        : '😓';

    // check if log already exists for today
    DailyLog? todayLog =
    state.firstWhereOrNull((log) => isSameDate(log.date, today));

    if (todayLog != null) {
      final updated = DailyLog(
        id: todayLog.id,
        date: today,
        completedTodos: completed,
        totalTodos: total,
        rating: rating,
        emoji: emoji,
        createdAt: todayLog.createdAt,
      );
      await updateLog(updated);
    } else {
      final newLog = DailyLog(
        id: '',
        date: today,
        completedTodos: completed,
        totalTodos: total,
        rating: rating,
        emoji: emoji,
        createdAt: today,
      );
      await addLog(newLog);
    }
  }


  Future<void> deleteLog(String id) async {
    if (_uid == null) return;
    await _repo.deleteLog(_uid!, id);
    fetchLogs();
  }
}
