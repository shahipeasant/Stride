import 'package:firebase_database/firebase_database.dart';

import '../model/event.dart';

class EventRepository {
  final _db = FirebaseDatabase.instance.ref();

  Future<List<Event>> fetchEvents(String uid) async {
    final snapshot = await _db.child('users/$uid/events').get();

    if (snapshot.exists && snapshot.value is Map) {
      final raw = snapshot.value as Map<Object?, Object?>;

      final events = raw.entries.map((entry) {
        final data = Map<String, dynamic>.from(entry.value as Map);
        return Event.fromMap(entry.key as String, data);
      }).toList();

      events.sort((a, b) => a.date.compareTo(b.date));
      return events;
    } else {
      return [];
    }
  }

  Future<String> addEvent(String uid, Event event) async {
    final newRef = _db.child('users/$uid/events').push();
    await newRef.set(event.toMap());
    return newRef.key!;
  }

  Future<void> updateEvent(String uid, Event event) async {
    await _db.child('users/$uid/events/${event.id}').update(event.toMap());
  }

  Future<void> deleteEvent(String uid, String eventId) async {
    await _db.child('users/$uid/events/$eventId').remove();
  }
}
