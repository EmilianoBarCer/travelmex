import 'package:flutter/foundation.dart';
import '../shared/models/destination.dart';
import '../core/services/supabase_service.dart';

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
