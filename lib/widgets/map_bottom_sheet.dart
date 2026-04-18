import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import '../models/destination.dart';

/// 🗺️ MapBottomSheet
/// Glassmorphism bottom sheet for destination details on map
class MapBottomSheet extends StatelessWidget {
  const MapBottomSheet({
    super.key,
    required this.destination,
    this.onClose,
    this.onViewDetails,
  });

  final Destination destination;
  final VoidCallback? onClose;
  final VoidCallback? onViewDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TmRadius.xl),
        boxShadow: [TmShadows.elevated],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(TmRadius.xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: TmColors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(TmRadius.xl),
              border: Border(
                top: BorderSide(
                  color: TmColors.white.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with close button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          destination.name,
                          style: TmTheme.light.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: onClose ?? () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                        style: IconButton.styleFrom(
                          backgroundColor: TmColors.grey100,
                          foregroundColor: TmColors.grey700,
                        ),
                      ),
                    ],
                  ),
                ),

                // Image and content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Destination Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(TmRadius.lg),
                        child: CachedNetworkImage(
                          imageUrl: destination.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 80,
                            height: 80,
                            color: TmColors.grey200,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 80,
                            height: 80,
                            color: TmColors.grey200,
                            child: const Icon(
                              Icons.image_not_supported,
                              color: TmColors.grey400,
                              size: 24,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Location
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: TmColors.grey500,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    destination.location,
                                    style: TmTheme.light.textTheme.bodyMedium?.copyWith(
                                      color: TmColors.grey600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Rating
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: TmColors.accent,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  destination.ratingAvg.toStringAsFixed(1),
                                  style: TmTheme.light.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Price
                            Text(
                              '\$${destination.pricePerNight.toStringAsFixed(0)} por noche',
                              style: TmTheme.light.textTheme.titleMedium?.copyWith(
                                color: TmColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Action button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onViewDetails ?? () {
                        // Navigate to details screen
                        Navigator.of(context).pushNamed(
                          '/details',
                          arguments: destination.id,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TmColors.primary,
                        foregroundColor: TmColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TmRadius.lg),
                        ),
                      ),
                      child: Text(
                        'Ver Detalles',
                        style: TmTheme.light.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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