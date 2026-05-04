import 'package:flutter/foundation.dart';

/// ⭐ Review Model
/// Immutable data class for destination reviews
@immutable
class Review {
  const Review({
    required this.id,
    required this.destinationId,
    required this.userId,
    required this.comment,
    required this.rating,
    required this.createdAt,
    this.userName,
    this.userAvatar,
  });

  final String id;
  final String destinationId;
  final String userId;
  final String comment;
  final int rating;
  final DateTime createdAt;
  final String? userName;
  final String? userAvatar;

  /// Factory constructor for Supabase deserialization
  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] as String,
      destinationId: map['destination_id'] as String,
      userId: map['user_id'] as String,
      comment: map['comment'] as String,
      rating: map['rating'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      userName: map['user_name'] as String?,
      userAvatar: map['user_avatar'] as String?,
    );
  }

  /// Convert to Map for Supabase operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'destination_id': destinationId,
      'user_id': userId,
      'comment': comment,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
      'user_name': userName,
      'user_avatar': userAvatar,
    };
  }

  /// Create a copy with updated fields
  Review copyWith({
    String? id,
    String? destinationId,
    String? userId,
    String? comment,
    int? rating,
    DateTime? createdAt,
    String? userName,
    String? userAvatar,
  }) {
    return Review(
      id: id ?? this.id,
      destinationId: destinationId ?? this.destinationId,
      userId: userId ?? this.userId,
      comment: comment ?? this.comment,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Review &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Review(id: $id, rating: $rating, comment: ${comment.substring(0, min(50, comment.length))}${comment.length > 50 ? "..." : ""})';
}

/// Utility function for min
int min(int a, int b) => a < b ? a : b;