import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category.dart';
import '../models/destination.dart';
import '../models/review.dart';
import '../models/user_profile.dart';

/// 🗄️ Supabase Service
/// Singleton service for all database operations
class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  static SupabaseService get instance => _instance;

  SupabaseService._internal();

  SupabaseClient get _client => Supabase.instance.client;

  /// 📂 Categories Operations

  /// Fetch all categories
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await _client.from('categories').select().order('name');

      return response.map((json) => Category.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  /// 📍 Destinations Operations

  /// Fetch all destinations with optional category filter
  Future<List<Destination>> fetchDestinations({int? categoryId}) async {
    try {
      var query = _client.from('destinations').select();

      if (categoryId != null && categoryId != -1) {
        query = query.eq('category_id', categoryId);
      }

      final response = await query
          .order('rating_avg', ascending: false)
          .order('created_at', ascending: false);

      return response.map((json) => Destination.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch destinations: $e');
    }
  }

  /// Fetch featured destinations
  Future<List<Destination>> fetchFeaturedDestinations() async {
    try {
      final response = await _client
          .from('destinations')
          .select()
          .eq('is_featured', true)
          .order('rating_avg', ascending: false)
          .limit(5);

      return response.map((json) => Destination.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch featured destinations: $e');
    }
  }

  /// Fetch destination by ID
  Future<Destination> fetchDestinationById(String id) async {
    try {
      final response =
          await _client.from('destinations').select().eq('id', id).single();

      return Destination.fromMap(response);
    } catch (e) {
      throw Exception('Failed to fetch destination: $e');
    }
  }

  /// Search destinations by name or location
  Future<List<Destination>> searchDestinations(String query) async {
    try {
      final response = await _client
          .from('destinations')
          .select()
          .or('name.ilike.%$query%,location.ilike.%$query%')
          .order('rating_avg', ascending: false);

      return response.map((json) => Destination.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Failed to search destinations: $e');
    }
  }

  /// ⭐ Reviews Operations

  /// Fetch reviews for a destination
  Future<List<Review>> fetchReviews(String destinationId) async {
    try {
      final response = await _client
          .from('reviews')
          .select('*, profiles:user_id(name, avatar_url)')
          .eq('destination_id', destinationId)
          .order('created_at', ascending: false);

      return response
          .map((json) => Review.fromMap({
                ...json,
                'user_name': json['profiles']?['name'],
                'user_avatar': json['profiles']?['avatar_url'],
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch reviews: $e');
    }
  }

  /// Fetch reviews created by a user
  Future<List<Review>> fetchReviewsByUser(String userId) async {
    try {
      final response = await _client
          .from('reviews')
          .select('*, profiles:user_id(name, avatar_url)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return response
          .map((json) => Review.fromMap({
                ...json,
                'user_name': json['profiles']?['name'],
                'user_avatar': json['profiles']?['avatar_url'],
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch user reviews: $e');
    }
  }

  /// Add a new review
  Future<Review> addReview({
    required String destinationId,
    required String userId,
    required String comment,
    required int rating,
  }) async {
    try {
      final response = await _client
          .from('reviews')
          .insert({
            'destination_id': destinationId,
            'user_id': userId,
            'comment': comment,
            'rating': rating,
          })
          .select('*, profiles:user_id(name, avatar_url)')
          .single();

      return Review.fromMap({
        ...response,
        'user_name': response['profiles']?['name'],
        'user_avatar': response['profiles']?['avatar_url'],
      });
    } catch (e) {
      throw Exception('Failed to add review: $e');
    }
  }

  /// 🔄 Realtime Subscriptions

  /// Subscribe to reviews for a destination
  Stream<List<Review>> subscribeToReviews(String destinationId) {
    return _client
        .from('reviews')
        .stream(primaryKey: ['id'])
        .eq('destination_id', destinationId)
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => Review.fromMap(json)).toList());
  }

  /// Subscribe to destination rating changes
  Stream<Destination> subscribeToDestinationRating(String destinationId) {
    return _client
        .from('destinations')
        .stream(primaryKey: ['id'])
        .eq('id', destinationId)
        .map((data) => data.isNotEmpty
            ? Destination.fromMap(data.first)
            : throw Exception('Destination not found'));
  }

  /// 🧩 Combined Operations

  /// Fetch destination with reviews
  Future<Map<String, dynamic>> fetchDestinationWithReviews(
      String destinationId) async {
    try {
      final results = await Future.wait([
        fetchDestinationById(destinationId),
        fetchReviews(destinationId),
      ]);

      return {
        'destination': results[0] as Destination,
        'reviews': results[1] as List<Review>,
      };
    } catch (e) {
      throw Exception('Failed to fetch destination with reviews: $e');
    }
  }

  /// 🗺️ Map Operations

  /// Fetch destinations within bounds (for map clustering)
  Future<List<Destination>> fetchDestinationsInBounds({
    required double northEastLat,
    required double northEastLng,
    required double southWestLat,
    required double southWestLng,
  }) async {
    try {
      final response = await _client
          .from('destinations')
          .select()
          .gte('latitude', southWestLat)
          .lte('latitude', northEastLat)
          .gte('longitude', southWestLng)
          .lte('longitude', northEastLng);

      return response.map((json) => Destination.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch destinations in bounds: $e');
    }
  }

  /// 👤 Profile Operations

  Future<UserProfile?> fetchProfileByUserId(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;
      return UserProfile.fromMap(response);
    } catch (e) {
      if (e is PostgrestException &&
          e.code == 'PGRST205' &&
          e.message.contains("public.profiles") == true) {
        throw Exception(
          'Error de base de datos: la tabla "profiles" no existe. Ejecuta sql/schema.sql en tu proyecto Supabase.',
        );
      }
      throw Exception('Failed to load profile: $e');
    }
  }

  Future<UserProfile> upsertProfile({
    required String userId,
    required String email,
    String? name,
    String? avatarUrl,
  }) async {
    try {
      final response = await _client
          .from('profiles')
          .upsert({
            'id': userId,
            'email': email,
            'name': name,
            'avatar_url': avatarUrl,
          }, onConflict: 'id')
          .select()
          .maybeSingle();

      if (response == null) {
        throw Exception('Failed to upsert profile: no response returned.');
      }

      return UserProfile.fromMap(response);
    } catch (e) {
      if (e is PostgrestException &&
          e.code == 'PGRST205' &&
          e.message.contains("public.profiles") == true) {
        throw Exception(
          'Error de base de datos: la tabla "profiles" no existe. Ejecuta sql/schema.sql en tu proyecto Supabase.',
        );
      }
      throw Exception('Failed to upsert profile: $e');
    }
  }
}
