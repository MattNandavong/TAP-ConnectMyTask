/// ---------------------------------------------------------------------------
/// File: chat_message.dart
/// Description: Defines the ChatMessage model representing a single message
/// exchanged between users, including sender/receiver IDs, text, optional
/// image, and timestamp.
/// Author: [Your Name]
/// Created: [Date]
/// ---------------------------------------------------------------------------


/// A model class representing a single chat message between two users.
class ChatMessage {
  final String id;
  final String sender;
  final String receiver;
  final String text;
  final String? image;
  final DateTime timestamp;

  /// Constructs a [ChatMessage] instance.
  ChatMessage({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.text,
    this.image,
    required this.timestamp,
  });

  /// Factory constructor to create a [ChatMessage] instance from JSON data.
  /// Handles cases where sender/receiver fields may be nested objects.
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'] ?? '',
      sender: json['sender'] is Map ? json['sender']['_id'] : json['sender'],
      receiver: json['receiver'] is Map ? json['receiver']['_id'] : json['receiver'],
      text: json['text'] ?? '',
      image: json['image'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
