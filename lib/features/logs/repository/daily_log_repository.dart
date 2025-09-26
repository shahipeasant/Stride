import 'package:firebase_database/firebase_database.dart';

import '../model/daily_log.dart';

class DailyLogRepository {
  final _db = FirebaseDatabase.instance.ref();

  Future<List<DailyLog>> fetchLogs(String uid) async {
    final snapshot = await _db.child('users/$uid/dailyLogs').get();

    if (snapshot.exists && snapshot.value is Map) {
      final raw = snapshot.value as Map<Object?, Object?>;

      final logs = raw.entries.map((entry) {
        final data = Map<String, dynamic>.from(entry.value as Map);
        return DailyLog.fromMap(entry.key as String, data);
      }).toList();

      logs.sort((a, b) => b.date.compareTo(a.date)); // newest first
      return logs;
    } else {
      return [];
    }
  }

  Future<void> addLog(String uid, DailyLog log) async {
    final newRef = _db.child('users/$uid/dailyLogs').push();
    await newRef.set(log.toMap());
  }

  Future<void> updateLog(String uid, DailyLog log) async {
    await _db.child('users/$uid/dailyLogs/${log.id}').update(log.toMap());
  }

  Future<void> deleteLog(String uid, String logId) async {
    await _db.child('users/$uid/dailyLogs/$logId').remove();
  }
}
