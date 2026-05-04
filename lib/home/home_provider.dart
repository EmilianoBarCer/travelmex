import 'package:flutter/foundation.dart';
import '../shared/models/category.dart' as tm;
import '../shared/models/destination.dart';
import '../core/services/supabase_service.dart';

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
