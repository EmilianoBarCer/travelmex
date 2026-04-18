import 'package:flutter/foundation.dart';
import '../models/category.dart' as tm;
import '../models/destination.dart';
import '../models/review.dart';
import '../services/supabase_service.dart';

/// 🏠 Home Provider
/// Manages home screen state: categories, destinations, featured content
class HomeProvider extends ChangeNotifier {
  HomeProvider() {
    loadInitialData();
  }

  final SupabaseService _service = SupabaseService.instance;

  // State
  List<tm.Category> _categories = [];
  List<Destination> _destinations = [];
  List<Destination> _featuredDestinations = [];
  bool _isLoading = true;
  String? _error;

  // Getters
  List<tm.Category> get categories => _categories;
  List<Destination> get destinations => _destinations;
  List<Destination> get featuredDestinations => _featuredDestinations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load initial data for home screen
  Future<void> loadInitialData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.fetchCategories(),
        _service.fetchDestinations(),
        _service.fetchFeaturedDestinations(),
      ]);

      _categories = results[0] as List<tm.Category>;
      _destinations = results[1] as List<Destination>;
      _featuredDestinations = results[2] as List<Destination>;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Filter destinations by category
  Future<void> filterByCategory(int categoryId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _destinations = await _service.fetchDestinations(categoryId: categoryId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh data
  Future<void> refresh() => loadInitialData();
}

/// 🔍 Search Provider
/// Manages search screen state: search results, map markers
class SearchProvider extends ChangeNotifier {
  final SupabaseService _service = SupabaseService.instance;

  // State
  List<Destination> _searchResults = [];
  bool _isSearching = false;
  String? _searchError;

  // Getters
  List<Destination> get searchResults => _searchResults;
  bool get isSearching => _isSearching;
  String? get searchError => _searchError;

  /// Search destinations
  Future<void> search(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isSearching = true;
    _searchError = null;
    notifyListeners();

    try {
      _searchResults = await _service.searchDestinations(query);
    } catch (e) {
      _searchError = e.toString();
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  /// Clear search results
  void clearSearch() {
    _searchResults = [];
    _searchError = null;
    notifyListeners();
  }

  /// Fetch destinations in map bounds
  Future<List<Destination>> fetchInBounds({
    required double northEastLat,
    required double northEastLng,
    required double southWestLat,
    required double southWestLng,
  }) async {
    try {
      return await _service.fetchDestinationsInBounds(
        northEastLat: northEastLat,
        northEastLng: northEastLng,
        southWestLat: southWestLat,
        southWestLng: southWestLng,
      );
    } catch (e) {
      _searchError = e.toString();
      notifyListeners();
      return [];
    }
  }
}

/// 📋 Details Provider
/// Manages destination details screen: destination data, reviews
class DetailsProvider extends ChangeNotifier {
  DetailsProvider(String destinationId) {
    loadDestination(destinationId);
  }

  final SupabaseService _service = SupabaseService.instance;

  // State
  Destination? _destination;
  List<Review> _reviews = [];
  bool _isLoading = true;
  String? _error;

  // Getters
  Destination? get destination => _destination;
  List<Review> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load destination with reviews
  Future<void> loadDestination(String destinationId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _service.fetchDestinationWithReviews(destinationId);
      _destination = data['destination'] as Destination;
      _reviews = data['reviews'] as List<Review>;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add a new review
  Future<bool> addReview({
    required String userId,
    required String comment,
    required int rating,
  }) async {
    if (_destination == null) return false;

    try {
      final newReview = await _service.addReview(
        destinationId: _destination!.id,
        userId: userId,
        comment: comment,
        rating: rating,
      );

      _reviews.insert(0, newReview);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Refresh reviews
  Future<void> refreshReviews() async {
    if (_destination == null) return;

    try {
      _reviews = await _service.fetchReviews(_destination!.id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}