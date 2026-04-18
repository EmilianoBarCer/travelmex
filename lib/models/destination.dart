import 'package:flutter/foundation.dart';

/// 🏖️ Destination Model
/// Immutable data class for travel destinations
@immutable
class Destination {
  const Destination({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.pricePerNight,
    required this.ratingAvg,
    required this.imageUrl,
    required this.categoryId,
    required this.createdAt,
    required this.latitude,
    required this.longitude,
    this.isFeatured = false,
  });

  final String id;
  final String name;
  final String description;
  final String location;
  final double pricePerNight;
  final double ratingAvg;
  final String imageUrl;
  final int categoryId;
  final DateTime createdAt;
  final double latitude;
  final double longitude;
  final bool isFeatured;

  /// Factory constructor for Supabase deserialization
  factory Destination.fromMap(Map<String, dynamic> map) {
    return Destination(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      location: map['location'] as String,
      pricePerNight: (map['price_per_night'] as num).toDouble(),
      ratingAvg: (map['rating_avg'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['image_url'] as String,
      categoryId: map['category_id'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      isFeatured: map['is_featured'] as bool? ?? false,
    );
  }

  /// Convert to Map for Supabase operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'price_per_night': pricePerNight,
      'rating_avg': ratingAvg,
      'image_url': imageUrl,
      'category_id': categoryId,
      'created_at': createdAt.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'is_featured': isFeatured,
    };
  }

  /// Create a copy with updated fields
  Destination copyWith({
    String? id,
    String? name,
    String? description,
    String? location,
    double? pricePerNight,
    double? ratingAvg,
    String? imageUrl,
    int? categoryId,
    DateTime? createdAt,
    double? latitude,
    double? longitude,
    bool? isFeatured,
  }) {
    return Destination(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      ratingAvg: ratingAvg ?? this.ratingAvg,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Destination &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Destination(id: $id, name: $name, rating: $ratingAvg, price: \$${pricePerNight.toStringAsFixed(0)})';
}