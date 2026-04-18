import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';
import '../../widgets/travel_card.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/shared_widgets.dart';
import '../../theme/app_theme.dart';

/// 🏠 HomeScreen
/// Main screen with SliverAppBar, featured destinations, and category filtering
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      child: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                // Gradient SliverAppBar
                _buildSliverAppBar(),

                // Content
                SliverToBoxAdapter(
                  child: provider.isLoading
                      ? _buildLoadingView()
                      : provider.error != null
                          ? _buildErrorView(provider)
                          : _buildContent(provider),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: TmColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                TmColors.primaryDark,
                TmColors.primary,
              ],
            ),
          ),
          child: Stack(
            children: [
              // Background pattern (optional)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.1,
                  child: Image.asset(
                    'assets/images/pattern.png', // Add this asset
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Descubre México',
                      style: TmTheme.light.textTheme.displaySmall?.copyWith(
                        color: TmColors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Explora los mejores destinos turísticos',
                      style: TmTheme.light.textTheme.bodyLarge?.copyWith(
                        color: TmColors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category chips loading
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) => ShimmerLoading(
                child: Container(
                  width: 80,
                  height: 36,
                  decoration: BoxDecoration(
                    color: TmColors.white,
                    borderRadius: BorderRadius.circular(TmRadius.full),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Featured section
          Text(
            'Destacados',
            style: TmTheme.light.textTheme.headlineSmall,
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) => const ShimmerCard(),
            ),
          ),

          const SizedBox(height: 32),

          // Nearby section
          Text(
            'Cerca de ti',
            style: TmTheme.light.textTheme.headlineSmall,
          ),

          const SizedBox(height: 16),

          // List items loading
          ...List.generate(
            3,
            (index) => ShimmerLoading(
              child: Container(
                height: 120,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: TmColors.white,
                  borderRadius: BorderRadius.circular(TmRadius.lg),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(HomeProvider provider) {
    return SizedBox(
      height: 400,
      child: ErrorView(
        error: provider.error!,
        onRetry: () => provider.refresh(),
      ),
    );
  }

  Widget _buildContent(HomeProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Filter
          CategoryChipList(
            categories: provider.categories,
            selectedCategoryId: _selectedCategoryId,
            onCategorySelected: (categoryId) {
              setState(() => _selectedCategoryId = categoryId);
              if (categoryId != null) {
                provider.filterByCategory(categoryId);
              }
            },
          ),

          const SizedBox(height: 24),

          // Featured Destinations
          if (provider.featuredDestinations.isNotEmpty) ...[
            Text(
              'Destacados',
              style: TmTheme.light.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: provider.featuredDestinations.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final destination = provider.featuredDestinations[index];
                  return TravelCard(
                    destination: destination,
                    onTap: () => _navigateToDetails(destination.id),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),
          ],

          // All Destinations
          Text(
            _selectedCategoryId != null && _selectedCategoryId != -1
                ? 'Resultados'
                : 'Todos los destinos',
            style: TmTheme.light.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 16),

          if (provider.destinations.isEmpty)
            const EmptyView(
              icon: Icons.search_off,
              title: 'No se encontraron destinos',
              subtitle: 'Intenta cambiar los filtros de búsqueda',
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.destinations.length,
              itemBuilder: (context, index) {
                final destination = provider.destinations[index];
                return TravelListCard(
                  destination: destination,
                  onTap: () => _navigateToDetails(destination.id),
                );
              },
            ),
        ],
      ),
    );
  }

  void _navigateToDetails(String destinationId) {
    Navigator.of(context).pushNamed('/details', arguments: destinationId);
  }
}