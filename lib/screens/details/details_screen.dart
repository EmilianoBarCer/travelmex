import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/auth_provider.dart';
import '../../providers/providers.dart';
import '../../widgets/shared_widgets.dart';
import '../../theme/app_theme.dart';
import '../../models/destination.dart';

/// 📋 DetailsScreen
/// Destination details with image gallery, reviews, and booking option
class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late String _destinationId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _destinationId = ModalRoute.of(context)!.settings.arguments as String;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailsProvider(_destinationId),
      child: Consumer<DetailsProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            body: provider.isLoading
                ? _buildLoadingView()
                : provider.error != null
                    ? _buildErrorView(provider)
                    : _buildContent(provider),
          );
        },
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorView(DetailsProvider provider) {
    return ErrorView(
      error: provider.error!,
      onRetry: () => provider.loadDestination(_destinationId),
    );
  }

  Widget _buildContent(DetailsProvider provider) {
    final destination = provider.destination!;
    final reviews = provider.reviews;

    return CustomScrollView(
      slivers: [
        // Hero Image with Back Button
        SliverAppBar(
          expandedHeight: 300,
          floating: false,
          pinned: true,
          backgroundColor: TmColors.white,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: TmColors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(TmRadius.lg),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: TmColors.grey900,
              ),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Hero(
              tag: 'destination_image_${destination.id}',
              child: CachedNetworkImage(
                imageUrl: destination.imageUrl,
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
                    size: 64,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Rating
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        destination.name,
                        style: TmTheme.light.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    // Rating Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: TmColors.accent,
                        borderRadius: BorderRadius.circular(TmRadius.full),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: TmColors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            destination.ratingAvg.toStringAsFixed(1),
                            style: TmTheme.light.textTheme.labelLarge?.copyWith(
                              color: TmColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Location
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: TmColors.grey500,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      destination.location,
                      style: TmTheme.light.textTheme.titleMedium?.copyWith(
                        color: TmColors.grey700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Price
                Text(
                  '\$${destination.pricePerNight.toStringAsFixed(0)} por noche',
                  style: TmTheme.light.textTheme.headlineMedium?.copyWith(
                    color: TmColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 24),

                // Description
                Text(
                  'Descripción',
                  style: TmTheme.light.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  destination.description,
                  style: TmTheme.light.textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 32),

                // Reviews Section
                Row(
                  children: [
                    Text(
                      'Reseñas',
                      style: TmTheme.light.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const Spacer(),

                    TextButton.icon(
                      onPressed: () => _showAddReviewDialog(context, provider),
                      icon: const Icon(
                        Icons.add,
                        color: TmColors.primary,
                      ),
                      label: Text(
                        'Agregar reseña',
                        style: TmTheme.light.textTheme.labelLarge?.copyWith(
                          color: TmColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                if (reviews.isEmpty)
                  const EmptyView(
                    icon: Icons.rate_review,
                    title: 'Sin reseñas aún',
                    subtitle: 'Sé el primero en compartir tu experiencia',
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      return ReviewCard(review: reviews[index]);
                    },
                  ),

                const SizedBox(height: 32),

                // Book Now Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showBookingDialog(context, destination),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TmColors.primary,
                      foregroundColor: TmColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TmRadius.lg),
                      ),
                    ),
                    child: Text(
                      'Reservar Ahora',
                      style: TmTheme.light.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAddReviewDialog(BuildContext context, DetailsProvider provider) {
    int selectedRating = 5;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Reseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Rating Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () => setState(() => selectedRating = index + 1),
                  icon: Icon(
                    index < selectedRating ? Icons.star : Icons.star_border,
                    color: TmColors.accent,
                    size: 32,
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),

            // Comment Field
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Comparte tu experiencia...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final authProvider = context.read<AuthProvider>();

              if (!authProvider.isAuthenticated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Debes iniciar sesión para dejar una reseña.')),
                );
                return;
              }

              if (commentController.text.isNotEmpty) {
                final success = await provider.addReview(
                  userId: authProvider.profile!.id,
                  comment: commentController.text,
                  rating: selectedRating,
                );

                if (success && context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reseña agregada exitosamente')),
                  );
                }
              }
            },
            child: const Text('Publicar'),
          ),
        ],
      ),
    );
  }

  void _showBookingDialog(BuildContext context, Destination destination) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reservar ${destination.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '¿Deseas proceder con la reserva de este destino?',
              style: TmTheme.light.textTheme.bodyMedium,
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: TmColors.grey50,
                borderRadius: BorderRadius.circular(TmRadius.md),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Precio por noche:'),
                      Text('\$${destination.pricePerNight.toStringAsFixed(0)}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Ubicación:'),
                      Text(destination.location),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reserva realizada exitosamente')),
              );
            },
            child: const Text('Confirmar Reserva'),
          ),
        ],
      ),
    );
  }
}