import 'package:flutter/foundation.dart';

/// 🏷️ Category Model
/// Immutable data class for destination categories
@immutable
class Category {
  const Category({
    required this.id,
    required this.name,
    required this.iconName,
  });

  final int id;
  final String name;
  final String iconName;

  /// Factory constructor for Supabase deserialization
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int,
      name: map['name'] as String,
      iconName: map['icon_name'] as String,
    );
  }

  /// Convert to Map for Supabase operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon_name': iconName,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          iconName == other.iconName;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ iconName.hashCode;

  @override
  String toString() => 'Category(id: $id, name: $name, iconName: $iconName)';
}