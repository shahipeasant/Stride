class Topic{
  String id;
  String topicName;
  String courseName;
  String detail;
  DateTime taughtAt;
  int studyCount;

  Topic({
    required this.id,
    required this.topicName,
    required this.courseName,
    required this.detail,
    required this.taughtAt,
    required this.studyCount,
  });

  Map<String, dynamic> toMap(){
    return {
      'topicName': topicName,
      'courseName': courseName,
      'detail': detail,
      'taughtAt': taughtAt.toIso8601String(),
      'studyCount': studyCount,
    };
  }

  factory Topic.fromMap(String id, Map<String, dynamic> map){
    return Topic(
      id: id,
      topicName: map['topicName'] ?? '',
      courseName: map['courseName'] ?? '',
      detail: map['detail'] ?? '',
      taughtAt: DateTime.parse(map['taughtAt'] ?? DateTime.now().toIso8601String()),
      studyCount: map['studyCount'] ?? 0,
    );
  }
}

List<Topic> topics = [];