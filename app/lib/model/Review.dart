/// ---------------------------------------------------------------------------
/// File: review.dart
/// Description: Defines the Review model representing feedback left by a user
/// after task completion, including rating, comment, reviewer details, and an
/// optional reference to the task title.
/// Author: [Your Name]
/// Created: [Date]
/// ---------------------------------------------------------------------------

import 'package:app/model/user.dart';

/// A model representing a review left by a user for a task.
class Review {
  final double rating;
  final String comment;
  final User reviewer;
  final String? taskTitle;

  Review({
    required this.rating,
    required this.comment,
    required this.reviewer,
    this.taskTitle,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'],
      reviewer: User.fromJson(json['reviewer']),
      taskTitle: json['task']?['title'],
    );
  }

  Map<String, dynamic> toJson() => {
    'rating': rating,
    'comment': comment,
    'reviewer': reviewer.toJson(),
  };
}
