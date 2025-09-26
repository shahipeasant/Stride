import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/daily_log_provider.dart';
import 'add_edit_daily_log.dart';

class DailyLogPage extends ConsumerStatefulWidget {
  const DailyLogPage({super.key});

  @override
  ConsumerState<DailyLogPage> createState() => _DailyLogPageState();
}

class _DailyLogPageState extends ConsumerState<DailyLogPage> {
  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      ref.read(dailyLogNotifierProvider.notifier).setUid(uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final logs = ref.watch(dailyLogNotifierProvider);

    return Scaffold(
      body: logs.isEmpty
          ? const Center(child: Text("No logs yet"))
          : ListView.builder(
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          final progress = log.totalTodos == 0
              ? 0.0
              : log.completedTodos / log.totalTodos;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(
                "${log.date.day}/${log.date.month}/${log.date.year}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 4),
                  Text("${log.completedTodos}/${log.totalTodos} todos completed"),
                  const SizedBox(height: 4),
                  Text("Rating: ${log.rating} ${log.emoji}"),
                ],
              ),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  ref.read(dailyLogNotifierProvider.notifier).deleteLog(log.id);
                },
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AddEditDailyLogDialog(existingLog: log),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const AddEditDailyLogDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
