import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/event.dart';
import '../providers/provider.dart';
import 'add_edit_event_dialog.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      ref.read(eventNotifierProvider.notifier).setUid(uid);
    }
  }

  List<Event> _getEventsForDay(DateTime day, List<Event> allEvents) {
    return allEvents
        .where((e) =>
    e.date.year == day.year &&
        e.date.month == day.month &&
        e.date.day == day.day)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(eventNotifierProvider);
    final selectedEvents =
    _selectedDay == null ? [] : _getEventsForDay(_selectedDay!, events);

    return Scaffold(
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            selectedDayPredicate: (day) =>
            _selectedDay != null &&
                day.year == _selectedDay!.year &&
                day.month == _selectedDay!.month &&
                day.day == _selectedDay!.day,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: selectedEvents.length,
              itemBuilder: (context, index) {
                final event = selectedEvents[index];
                return Card(
                  child: ListTile(
                    title: Text(event.title),
                    subtitle: Text(event.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        ref
                            .read(eventNotifierProvider.notifier)
                            .deleteEvent(event.id);
                      },
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) =>
                            AddEditEventDialog(existingEvent: event),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedDay == null) _selectedDay = DateTime.now();
          showDialog(
            context: context,
            builder: (_) =>
                AddEditEventDialog(selectedDate: _selectedDay),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
