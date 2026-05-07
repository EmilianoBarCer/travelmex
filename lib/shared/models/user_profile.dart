import 'package:flutter/foundation.dart';

@immutable
class UserProfile {
  const UserProfile({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    this.bio,
    this.location,
    this.createdAt,
  });

  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;
  final String? bio;      // ✅ nuevo
  final String? location; // ✅ nuevo
  final DateTime? createdAt;

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String?,
      avatarUrl: map['avatar_url'] as String?,
      bio: map['bio'] as String?,           // ✅
      location: map['location'] as String?, // ✅
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
      'bio': bio,           // ✅
      'location': location, // ✅
      'created_at': createdAt?.toIso8601String(),
    };
  }
}