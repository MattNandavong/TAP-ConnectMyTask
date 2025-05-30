/// ---------------------------------------------------------------------------
/// File: chat_preview.dart
/// Description: Defines the ChatPreview model used to summarize recent chat
/// activity with a user, including their ID, name, profile image, last message,
/// timestamp, and unread message count.
/// Author: [Your Name]
/// Created: [Date]
/// ---------------------------------------------------------------------------


/// A model representing a summary preview of a chat conversation,
/// typically used in a message list or inbox view.
class ChatPreview {
  final String userId;
  final String name;
  final String? profilePhoto;
  final String? lastMessage;
  final String? lastImage;
  final DateTime lastTimestamp;
  final int unreadCount;

  /// Constructs a [ChatPreview] instance.
  ChatPreview({
    required this.userId,
    required this.name,
    this.profilePhoto,
    this.lastMessage,
    this.lastImage,
    required this.lastTimestamp,
    required this.unreadCount,
  });

  /// Factory constructor to create a [ChatPreview] instance from JSON data.
  factory ChatPreview.fromJson(Map<String, dynamic> json) {
    return ChatPreview(
      userId: json['userId'],
      name: json['name'],
      profilePhoto: json['profilePhoto'],
      lastMessage: json['lastMessage'],
      lastImage: json['lastImage'],
      lastTimestamp: DateTime.parse(json['lastTimestamp']),
      unreadCount: json['unreadCount'] ?? 0
    );
  }
}
