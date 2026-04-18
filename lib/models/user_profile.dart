import 'package:flutter/foundation.dart';

/// 👤 User Profile
/// Stores the authenticated user profile information.
@immutable
class UserProfile {
  const UserProfile({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    this.createdAt,
  });

  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;
  final DateTime? createdAt;

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String?,
      avatarUrl: map['avatar_url'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
