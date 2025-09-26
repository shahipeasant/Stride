import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../model/topic.dart';
import '../repository/topic_repository.dart';

/// Repository provider
final topicRepositoryProvider = Provider<TopicRepository>((ref) {
  return TopicRepository();
});

/// Async list of topics
final topicsProvider = FutureProvider<List<Topic>>((ref) async {
  final repo = ref.watch(topicRepositoryProvider);
  return repo.fetchTopics(FirebaseAuth.instance.currentUser!.uid);
});

enum TopicFilter { all, studied, notStudied }

/// StateNotifier for topic actions (CRUD)
class TopicNotifier extends StateNotifier<AsyncValue<List<Topic>>> {
  final TopicRepository repo;
  TopicNotifier(this.repo) : super(const AsyncValue.loading()) {
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    try {
      final data = await repo.fetchTopics(FirebaseAuth.instance.currentUser!.uid);
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTopic(Topic topic) async {
    await repo.addTopic(topic);
    _loadTopics();
  }

  Future<void> incrementStudy(Topic topic) async {
    await repo.incrementStudyCount(topic);
    _loadTopics();
  }

  Future<void> deleteTopic(Topic topic) async {
    await repo.deleteTopic(topic);
    _loadTopics();
  }
}

final topicNotifierProvider =
StateNotifierProvider<TopicNotifier, AsyncValue<List<Topic>>>((ref) {
  return TopicNotifier(ref.watch(topicRepositoryProvider));
});
