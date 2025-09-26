import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../model/event.dart';
import '../repository/event_repository.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository();
});

final eventNotifierProvider =
StateNotifierProvider<EventNotifier, List<Event>>((ref) {
  final repo = ref.watch(eventRepositoryProvider);
  return EventNotifier(repo);
});

class EventNotifier extends StateNotifier<List<Event>> {
  final EventRepository _repo;
  String? _uid;

  EventNotifier(this._repo) : super([]);

  void setUid(String uid) {
    _uid = uid;
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    if (_uid == null) return;
    final events = await _repo.fetchEvents(_uid!);
    state = events;
  }

  Future<void> addEvent(Event event) async {
    if (_uid == null) return;
    await _repo.addEvent(_uid!, event);
    fetchEvents();
  }

  Future<void> updateEvent(Event event) async {
    if (_uid == null) return;
    await _repo.updateEvent(_uid!, event);
    fetchEvents();
  }

  Future<void> deleteEvent(String id) async {
    if (_uid == null) return;
    await _repo.deleteEvent(_uid!, id);
    fetchEvents();
  }
}
