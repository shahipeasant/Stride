import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/topic.dart';
import '../providers/topic_provider.dart';

class AddTopicDialog extends ConsumerStatefulWidget {
  const AddTopicDialog({super.key});

  @override
  ConsumerState<AddTopicDialog> createState() => _AddTopicDialogState();
}

class _AddTopicDialogState extends ConsumerState<AddTopicDialog> {
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();
  final _courseController = TextEditingController();
  final _detailController = TextEditingController();

  @override
  void dispose() {
    _topicController.dispose();
    _courseController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Topic"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _topicController,
                decoration: const InputDecoration(hintText: "Topic name"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(hintText: "Course name"),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _detailController,
                decoration: const InputDecoration(hintText: "Details"),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState?.validate() ?? false) {
              final newTopic = Topic(
                id: '', // will be set in repository
                topicName: _topicController.text.trim(),
                courseName: _courseController.text.trim(),
                detail: _detailController.text.trim(),
                taughtAt: DateTime.now(), studyCount: 0,
              );

              await ref
                  .read(topicNotifierProvider.notifier)
                  .addTopic(newTopic);

              if (context.mounted) Navigator.pop(context);
            }
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}
