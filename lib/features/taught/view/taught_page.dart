import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stride/features/taught/repository/topic_repository.dart';

import '../model/topic.dart';
import '../providers/topic_provider.dart';
import 'add_topic_dialog.dart';

Widget _buildCourseDropdown(WidgetRef ref, List<Topic> topics) {
  final courseFilter = ref.watch(courseFilterProvider);

  // unique course names
  final courses = topics.map((t) => t.courseName).toSet().toList();

  return DropdownButton<String?>(
    value: courseFilter,
    hint: const Text("Select Course"),
    isExpanded: true,
    items: [
      const DropdownMenuItem<String?>(
        value: null,
        child: Text("All Courses"),
      ),
      ...courses.map((course) => DropdownMenuItem<String?>(
        value: course,
        child: Text(course),
      )),
    ],
    onChanged: (value) {
      ref.read(courseFilterProvider.notifier).state = value;
    },
  );
}

Widget _buildStudyDropdown(WidgetRef ref) {
  final studyFilter = ref.watch(studyCountFilterProvider);

  return DropdownButton<int?>(
    value: studyFilter,
    hint: const Text("Study Count"),
    isExpanded: true,
    items: const [
      DropdownMenuItem<int?>(
        value: null,
        child: Text("All"),
      ),
      DropdownMenuItem<int?>(
        value: 0,
        child: Text("0 times"),
      ),
      DropdownMenuItem<int?>(
        value: 1,
        child: Text("1 time"),
      ),
      DropdownMenuItem<int?>(
        value: 2,
        child: Text("2+ times"),
      ),
    ],
    onChanged: (value) {
      ref.read(studyCountFilterProvider.notifier).state = value;
    },
  );
}


class TaughtPage extends ConsumerWidget {
  const TaughtPage({super.key});

  Color _getStudyColor(int studyCount) {
    if (studyCount == 0) return Colors.grey.shade300;
    if (studyCount == 1) return Colors.green.shade600;
    return Color(0xff606c38); // studied 2+ times
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topicsState = ref.watch(topicNotifierProvider);
    final filteredTopics = ref.watch(filteredTopicsProvider);

    return Scaffold(
      body: topicsState.when(
        data: (topics) {
          if (topics.isEmpty) {
            return const Center(child: Text("No topics yet"));
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: _buildCourseDropdown(ref, topics),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: _buildStudyDropdown(ref),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTopics.length,
                  itemBuilder: (context, index) {
                    final topic = filteredTopics[index];
                    return Card(
                      color: _getStudyColor(topic.studyCount),
                      child: ListTile(
                        title: Text(topic.topicName),
                        subtitle: Text(
                          "${topic.courseName}\n${topic.detail}\nStudied ${topic.studyCount}x",
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            ref.read(topicNotifierProvider.notifier).deleteTopic(topic);
                          },
                        ),
                        isThreeLine: true,
                        onTap: () {
                          ref.read(topicNotifierProvider.notifier).incrementStudy(topic);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
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
        },
        child: const Icon(Icons.add),
      ),
    );
  }

}

