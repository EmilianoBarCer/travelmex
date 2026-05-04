import 'package:flutter/foundation.dart';
import '../shared/models/destination.dart';
import '../shared/models/review.dart';
import '../core/services/supabase_service.dart';

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