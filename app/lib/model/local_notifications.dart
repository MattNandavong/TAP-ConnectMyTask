class LocalNotification {
  final String title;
  final String body;
  final DateTime timestamp;
  bool read;

   final String? type;       // 'chat' or 'task'
  final String? taskId;     // for task notifications
  final String? receiverId; // for chat notifications

  LocalNotification({
    required this.title,
    required this.body,
    required this.timestamp,
    this.type,
    this.taskId,
    this.receiverId,
    this.read = false,
  });

  factory LocalNotification.fromJson(Map<String, dynamic> json) {
    return LocalNotification(
      title: json['title'],
      body: json['body'],
      timestamp: DateTime.parse(json['timestamp']),
      type: json['type'],
      taskId: json['taskId'],
      receiverId: json['receiverId'],
      read: json['read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'body': body,
    'timestamp': timestamp.toIso8601String(),
    'type': type,
    'taskId': taskId,
    'receiverId': receiverId,
    'read': read,
  };
}
