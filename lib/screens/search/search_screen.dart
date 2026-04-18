import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';
import '../../widgets/travel_card.dart';
import '../../widgets/map_bottom_sheet.dart';
import '../../widgets/shared_widgets.dart';
import '../../theme/app_theme.dart';

/// 🔍 SearchScreen
/// Search and map view for destinations
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
      child: Consumer<SearchProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Buscar Destinos',
                style: TmTheme.light.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Buscar'),
                  Tab(text: 'Mapa'),
                ],
                labelStyle: TmTheme.light.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TmTheme.light.textTheme.labelLarge,
                indicatorColor: TmColors.primary,
                labelColor: TmColors.primary,
                unselectedLabelColor: TmColors.grey600,
              ),
            ),

            body: TabBarView(
              controller: _tabController,
              children: [
                _buildSearchTab(provider),
                _buildMapTab(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchTab(SearchProvider provider) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(20),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar destinos, ciudades, lugares...',
              prefixIcon: const Icon(
                Icons.search,
                color: TmColors.grey500,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        provider.clearSearch();
                      },
                      icon: const Icon(
                        Icons.clear,
                        color: TmColors.grey500,
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TmRadius.lg),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: TmColors.grey50,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: (value) => provider.search(value),
          ),
        ),

        // Results
        Expanded(
          child: provider.isSearching
              ? _buildSearchingView()
              : provider.searchError != null
                  ? _buildSearchErrorView(provider)
                  : _buildSearchResults(provider),
        ),
      ],
    );
  }

  Widget _buildSearchingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Buscando...'),
        ],
      ),
    );
  }

  Widget _buildSearchErrorView(SearchProvider provider) {
    return ErrorView(
      error: provider.searchError!,
      onRetry: () => provider.search(_searchController.text),
    );
  }

  Widget _buildSearchResults(SearchProvider provider) {
    if (_searchController.text.isEmpty) {
      return const EmptyView(
        icon: Icons.search,
        title: 'Buscar destinos',
        subtitle: 'Ingresa el nombre de un lugar o ciudad para encontrar destinos turísticos',
      );
    }

    if (provider.searchResults.isEmpty) {
      return const EmptyView(
        icon: Icons.search_off,
        title: 'No se encontraron resultados',
        subtitle: 'Intenta con otros términos de búsqueda',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: provider.searchResults.length,
      itemBuilder: (context, index) {
        final destination = provider.searchResults[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TravelListCard(
            destination: destination,
            onTap: () => _navigateToDetails(destination.id),
          ),
        );
      },
    );
  }

  Widget _buildMapTab(SearchProvider provider) {
    return DestinationMap(
      destinations: provider.searchResults.isNotEmpty
          ? provider.searchResults
          : [], // In a real app, you'd load all destinations
      onDestinationTap: (destination) => _showDestinationBottomSheet(destination),
    );
  }

  void _showDestinationBottomSheet(destination) {
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
            _navigateToDetails(destination.id);
          },
        ),
      ),
    );
  }

  void _navigateToDetails(String destinationId) {
    Navigator.of(context).pushNamed('/details', arguments: destinationId);
  }
}