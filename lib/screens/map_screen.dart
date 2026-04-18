import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/destination.dart';
import '../services/supabase_service.dart';
import '../widgets/map_bottom_sheet.dart';
import '../widgets/shared_widgets.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final SupabaseService _service = SupabaseService.instance;
  final List<Destination> _destinations = [];
  final Set<Marker> _markers = {};
  bool _isLoading = true;
  String? _error;
  GoogleMapController? _mapController;

  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(20.6534, -88.4462),
    zoom: 6.8,
  );

  @override
  void initState() {
    super.initState();
    _loadDestinations();
  }

  Future<void> _loadDestinations() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final destinations = await _service.fetchDestinations();
      setState(() {
        _destinations.clear();
        _destinations.addAll(destinations);
        _markers.clear();
        _markers.addAll(destinations.map(_createMarker));
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Marker _createMarker(Destination destination) {
    return Marker(
      markerId: MarkerId(destination.id),
      position: LatLng(destination.latitude, destination.longitude),
      infoWindow: InfoWindow(
        title: destination.name,
        snippet: destination.location,
        onTap: () => _showDestinationBottomSheet(destination),
      ),
      onTap: () => _showDestinationBottomSheet(destination),
    );
  }

  void _showDestinationBottomSheet(Destination destination) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        builder: (context, scrollController) => MapBottomSheet(
          destination: destination,
          onViewDetails: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/details', arguments: destination.id);
          },
        ),
      ),
    );
  }

  Future<void> _recenterMap() async {
    if (_destinations.isEmpty || _mapController == null) return;

    final latitudes = _destinations.map((destination) => destination.latitude).toList();
    final longitudes = _destinations.map((destination) => destination.longitude).toList();

    if (latitudes.isEmpty || longitudes.isEmpty) return;

    final north = latitudes.reduce((value, element) => value > element ? value : element);
    final south = latitudes.reduce((value, element) => value < element ? value : element);
    final east = longitudes.reduce((value, element) => value > element ? value : element);
    final west = longitudes.reduce((value, element) => value < element ? value : element);

    final bounds = LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );

    await _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 64));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? ErrorView(
                  error: _error!,
                  onRetry: _loadDestinations,
                )
              : Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: _initialCamera,
                      markers: _markers,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                    ),
                    Positioned(
                      right: 16,
                      bottom: 24,
                      child: FloatingActionButton(
                        onPressed: _recenterMap,
                        mini: true,
                        child: const Icon(Icons.my_location),
                      ),
                    ),
                  ],
                ),
    );
  }
}
