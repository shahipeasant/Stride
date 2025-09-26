import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stride/features/taught/repository/topic_repository.dart';

import '../model/topic.dart';
import '../providers/topic_provider.dart';
import 'add_topic_dialog.dart';

class TaughtPage extends ConsumerWidget {
  const TaughtPage({super.key});

  Color _getStudyColor(int studyCount) {
    if (studyCount == 0) return Colors.grey.shade300;
    if (studyCount == 1) return Colors.lightGreen.shade200;
    if (studyCount == 2) return Colors.green.shade400;
    return Colors.green.shade800; // studied 3+ times
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topicsState = ref.watch(topicNotifierProvider);

    return Scaffold(
      body: topicsState.when(
        data: (topics) {
          if (topics.isEmpty) {
            return const Center(child: Text("No topics yet"));
          }
          return ListView.builder(
            itemCount: topics.length,
            itemBuilder: (context, index) {
              final topic = topics[index];
              return Card(
                color: _getStudyColor(topic.studyCount),
                child: ListTile(
                  title: Text(topic.topicName),
                  subtitle: Text("${topic.courseName}\n${topic.detail}"),
                  isThreeLine: true,
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Studied \n${topic.studyCount}x", style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  onTap: () {
                    ref.read(topicNotifierProvider.notifier).incrementStudy(topic);
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (_) => const AddTopicDialog(),
          );
          final newTopic = Topic(
            id: '',
            topicName: "New Topic",
            courseName: "Course",
            detail: "Details...",
            taughtAt: DateTime.now(),
            studyCount: 0,
          );
          await ref.read(topicNotifierProvider.notifier).addTopic(newTopic);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

