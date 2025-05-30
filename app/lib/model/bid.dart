/// ---------------------------------------------------------------------------
/// File: bid.dart
/// Description: Defines the Bid model used to represent a service provider's
/// bid on a task, including pricing, provider ID, comment, time estimate, and
/// date of submission.
/// Author: [Your Name]
/// Created: [Date]
/// ---------------------------------------------------------------------------
/// 
/// 
/// /// A model class representing a bid submitted by a service provider.
class Bid {
  final String id;
  final String provider; // Just the provider ID
  final double price;
  final String? comment;
  final dynamic estimatedTime;
  final DateTime date;

  /// Constructs a [Bid] instance.
  Bid({
    required this.id,
    required this.provider,
    required this.price,
    this.comment,
    required this.estimatedTime,
    required this.date,
  });

  /// Factory constructor to create a [Bid] instance from JSON data.
  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      id: json['_id'],
      provider: json['provider'],
      comment: json['comment'] ?? "No comment",
      price: (json['price'] as num).toDouble(),
      estimatedTime: json['estimatedTime'].toString(),
      date: DateTime.parse(json['date']),
    );
  }

  /// Converts the [Bid] instance into a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'provider': provider,
      'price': price,
      'comment': comment,
      'estimatedTime': estimatedTime,
      'date': date.toIso8601String(),
    };
  }

}
