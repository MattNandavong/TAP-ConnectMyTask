class ChatMessage {
  final String id;
  final String sender;
  final String receiver;
  final String text;
  final String? image;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.text,
    this.image,
    required this.timestamp,
  });

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
