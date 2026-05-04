import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../models/destination.dart';

/// 🗺️ DestinationMap
/// Placeholder widget for map integration
/// Note: This requires google_maps_flutter or similar package
class DestinationMap extends StatelessWidget {
  const DestinationMap({
    super.key,
    required this.destinations,
    this.onDestinationTap,
    this.initialLatitude = 20.6534, // Yucatán center
    this.initialLongitude = -88.4462,
    this.initialZoom = 7.8,
  });

  final List<Destination> destinations;
  final ValueChanged<Destination>? onDestinationTap;
  final double initialLatitude;
  final double initialLongitude;
  final double initialZoom;

  Set<Marker> _buildMarkers() {
    return destinations
        .map(
          (destination) => Marker(
        markerId: MarkerId(destination.id),
        position: LatLng(destination.latitude, destination.longitude),
        infoWindow: InfoWindow(
          title: destination.name,
          snippet: destination.location,
          onTap: () => onDestinationTap?.call(destination),
        ),
        onTap: () => onDestinationTap?.call(destination),
      ),
    )
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final isMapSupported = kIsWeb || [
      TargetPlatform.android,
      TargetPlatform.iOS,
    ].contains(defaultTargetPlatform);

    if (!isMapSupported) {
      return Container(
        color: TmColors.grey100,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.map, size: 64, color: TmColors.grey400),
                const SizedBox(height: 16),
                Text(
                  'Mapa no disponible en esta plataforma',
                  textAlign: TextAlign.center,
                  style: TmTheme.light.textTheme.headlineSmall?.copyWith(
                    color: TmColors.grey600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(initialLatitude, initialLongitude),
        zoom: initialZoom,
      ),
      markers: _buildMarkers(),
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      mapType: MapType.normal,
    );
  }
}