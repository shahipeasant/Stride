import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/daily_log.dart';
import '../providers/daily_log_provider.dart';

class AddEditDailyLogDialog extends ConsumerStatefulWidget {
  final DailyLog? existingLog;

  const AddEditDailyLogDialog({super.key, this.existingLog});

  @override
  ConsumerState<AddEditDailyLogDialog> createState() =>
      _AddEditDailyLogDialogState();
}

class _AddEditDailyLogDialogState
    extends ConsumerState<AddEditDailyLogDialog> {
  late TextEditingController _contentController;
  int _rating = 0;
  String _emoji = '';

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(
        text: widget.existingLog != null ? widget.existingLog!.completedTodos.toString() : '');
    _rating = widget.existingLog?.rating ?? 0;
    _emoji = widget.existingLog?.emoji ?? '';
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existingLog != null ? "Edit Log" : "Add Log"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(labelText: "Notes/Content"),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text("Rating: "),
              DropdownButton<int>(
                value: _rating,
                items: List.generate(6, (index) => index)
                    .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _rating = v);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(labelText: "Emoji (optional)"),
            onChanged: (v) => _emoji = v,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            final log = DailyLog(
              id: widget.existingLog?.id ?? '',
              date: widget.existingLog?.date ?? DateTime.now(),
              completedTodos: widget.existingLog?.completedTodos ?? 0,
              totalTodos: widget.existingLog?.totalTodos ?? 0,
              rating: _rating,
              emoji: _emoji,
              createdAt: widget.existingLog?.createdAt ?? DateTime.now(),
            );

            if (widget.existingLog != null) {
              ref.read(dailyLogNotifierProvider.notifier).updateLog(log);
            } else {
              ref.read(dailyLogNotifierProvider.notifier).addLog(log);
            }

            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
