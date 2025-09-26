import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/event.dart';
import '../providers/provider.dart';

class AddEditEventDialog extends ConsumerStatefulWidget {
  final Event? existingEvent;
  final DateTime? selectedDate;

  const AddEditEventDialog({super.key, this.existingEvent, this.selectedDate});

  @override
  ConsumerState<AddEditEventDialog> createState() =>
      _AddEditEventDialogState();
}

class _AddEditEventDialogState extends ConsumerState<AddEditEventDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.existingEvent?.title ?? '');
    _descController =
        TextEditingController(text: widget.existingEvent?.description ?? '');
    _date = widget.existingEvent?.date ?? widget.selectedDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existingEvent != null ? "Edit Event" : "Add Event"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _titleController, decoration: const InputDecoration(labelText: "Title")),
          const SizedBox(height: 8),
          TextField(controller: _descController, decoration: const InputDecoration(labelText: "Description")),
          const SizedBox(height: 8),
          TextButton(
            child: Text("Select Date: ${_date.day}/${_date.month}/${_date.year}"),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null) setState(() => _date = picked);
            },
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            final event = Event(
              id: widget.existingEvent?.id ?? '',
              title: _titleController.text.trim(),
              description: _descController.text.trim(),
              date: _date,
              createdAt: widget.existingEvent?.createdAt ?? DateTime.now(),
            );

            if (widget.existingEvent != null) {
              ref.read(eventNotifierProvider.notifier).updateEvent(event);
            } else {
              ref.read(eventNotifierProvider.notifier).addEvent(event);
            }
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
