import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import '../models/destination.dart';

/// 🏖️ TravelCard
/// High-fidelity card widget for destinations with Hero transitions
class TravelCard extends StatelessWidget {
  const TravelCard({
    super.key,
    required this.destination,
    this.width,
    this.height,
    this.onTap,
  });

  final Destination destination;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 280,
        height: height ?? 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TmRadius.lg),
          boxShadow: [TmShadows.card],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(TmRadius.lg),
          child: Stack(
            children: [
              // Background Image with Hero
              Hero(
                tag: 'destination_image_${destination.id}',
                child: CachedNetworkImage(
                  imageUrl: destination.imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: TmColors.grey200,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: TmColors.grey200,
                    child: const Icon(
                      Icons.image_not_supported,
                      color: TmColors.grey400,
                      size: 48,
                    ),
                  ),
                ),
              ),

              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),

                    // Title and Location
                    Text(
                      destination.name,
                      style: TmTheme.light.textTheme.titleLarge?.copyWith(
                        color: TmColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: TmColors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            destination.location,
                            style: TmTheme.light.textTheme.bodySmall?.copyWith(
                              color: TmColors.white.withValues(alpha: 0.9),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Rating and Price Row
                    _RatingRow(destination: destination),
                  ],
                ),
              ),

              // Price Badge
              Positioned(
                top: 12,
                right: 12,
                child: _PriceBadge(price: destination.pricePerNight),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 📋 TravelListCard
/// Compact card for list views
class TravelListCard extends StatelessWidget {
  const TravelListCard({
    super.key,
    required this.destination,
    this.onTap,
  });

  final Destination destination;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: TmColors.white,
          borderRadius: BorderRadius.circular(TmRadius.lg),
          boxShadow: [TmShadows.card],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(TmRadius.lg),
                bottomLeft: Radius.circular(TmRadius.lg),
              ),
              child: CachedNetworkImage(
                imageUrl: destination.imageUrl,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 120,
                  height: 120,
                  color: TmColors.grey200,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 120,
                  height: 120,
                  color: TmColors.grey200,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: TmColors.grey400,
                    size: 32,
                  ),
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      destination.name,
                      style: TmTheme.light.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Location
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: TmColors.grey500,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            destination.location,
                            style: TmTheme.light.textTheme.bodySmall?.copyWith(
                              color: TmColors.grey600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Rating and Price
                    Row(
                      children: [
                        _RatingRow(destination: destination, compact: true),
                        const Spacer(),
                        Text(
                          '\$${destination.pricePerNight.toStringAsFixed(0)}',
                          style: TmTheme.light.textTheme.titleMedium?.copyWith(
                            color: TmColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '/noche',
                          style: TmTheme.light.textTheme.bodySmall?.copyWith(
                            color: TmColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ⭐ Rating Row Widget
class _RatingRow extends StatelessWidget {
  const _RatingRow({
    required this.destination,
    this.compact = false,
  });

  final Destination destination;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.star,
          color: TmColors.accent,
          size: compact ? 16 : 18,
        ),
        const SizedBox(width: 4),
        Text(
          destination.ratingAvg.toStringAsFixed(1),
          style: (compact
                  ? TmTheme.light.textTheme.bodySmall
                  : TmTheme.light.textTheme.bodyMedium)
              ?.copyWith(
            color: TmColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// 💰 Price Badge Widget
class _PriceBadge extends StatelessWidget {
  const _PriceBadge({required this.price});

  final double price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: TmColors.accent,
        borderRadius: BorderRadius.circular(TmRadius.full),
        boxShadow: [TmShadows.floating],
      ),
      child: Text(
        '\$${price.toStringAsFixed(0)}',
        style: TmTheme.light.textTheme.labelLarge?.copyWith(
          color: TmColors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}