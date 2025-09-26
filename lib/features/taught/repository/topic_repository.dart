import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../model/topic.dart';

class TopicRepository{
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  String _userPath(){
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if(uid == null){
      throw Exception("User not logged in");
    }
    return 'users/$uid/topics';
  }

  /// Fetch all topics
  Future<List<Topic>> fetchTopics(String uid) async {
    final snapshot = await _db.child('users/$uid/topics').get();

    if (snapshot.exists && snapshot.value is Map) {
      final raw = snapshot.value as Map<Object?, Object?>;

      final topics = raw.entries.map((entry) {
        final data = Map<String, dynamic>.from(entry.value as Map);
        return Topic.fromMap(entry.key as String, data);
      }).toList();

      return topics;
    } else {
      return [];
    }
  }

  /// Add a new topic
  Future<void> addTopic(Topic topic) async {
    final ref = _db.child(_userPath()).push(); // auto-generated id
    await ref.set(topic.toMap());
    topic.id = ref.key!;
  }

  /// Increment studyCount for a topic
  Future<void> incrementStudyCount(Topic topic) async {
    final ref = _db.child('${_userPath()}/${topic.id}');
    await ref.update({'studyCount': topic.studyCount + 1});
  }

  /// Update any field of a topic
  Future<void> updateTopic(Topic topic) async {
    final ref = _db.child('${_userPath()}/${topic.id}');
    await ref.update(topic.toMap());
  }

  /// Delete a topic
  Future<void> deleteTopic(Topic topic) async {
    final ref = _db.child('${_userPath()}/${topic.id}');
    await ref.remove();
  }

}