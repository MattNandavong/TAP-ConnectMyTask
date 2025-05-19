class ChatPreview {
  final String userId;
  final String name;
  final String? profilePhoto;
  final String? lastMessage;
  final String? lastImage;
  final DateTime lastTimestamp;
  final int unreadCount;

  ChatPreview({
    required this.userId,
    required this.name,
    this.profilePhoto,
    this.lastMessage,
    this.lastImage,
    required this.lastTimestamp,
    required this.unreadCount,
  });

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
