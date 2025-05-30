/// ---------------------------------------------------------------------------
/// File: local_notification.dart
/// Description: Defines the LocalNotification model used to represent local
/// in-app notifications, including metadata such as type, timestamp, task/chat
/// associations, and read status.
/// Author: [Your Name]
/// Created: [Date]
/// ---------------------------------------------------------------------------


/// A model representing a local in-app notification.
class LocalNotification {
  final String title;
  final String body;
  final DateTime timestamp;
  bool read;

  final String? type; // 'chat' or 'task'
  final String? taskId; // for task notifications
  final String? receiverId; // for chat notifications

  /// Constructs a [LocalNotification] instance.
  LocalNotification({
    required this.title,
    required this.body,
    required this.timestamp,
    this.type,
    this.taskId,
    this.receiverId,
    this.read = false,
  });

  /// Factory constructor to create a [LocalNotification] instance from JSON.
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

  /// Converts the [LocalNotification] instance to a JSON-compatible map.
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
