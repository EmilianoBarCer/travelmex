import 'package:flutter/material.dart';
import '../models/place_model.dart';

class LocationScreen extends StatelessWidget {
  final Place place;

  const LocationScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(place.name, style: const TextStyle(color: Colors.white, shadows: [Shadow(blurRadius: 10, color: Colors.black)])),
              background: Hero(
                tag: place.id,
                child: Image.network(place.imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Placeholder para el Mapa de Google
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map_outlined, size: 50, color: Colors.grey),
                        Text('Mapa interactivo (Google Maps API) irá aquí'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text('Reseñas', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildReviewTile('Carlos M.', '¡El mejor lugar de la zona! Totalmente recomendado.', 5),
                  _buildReviewTile('Laura S.', 'Muy bonito, pero había mucha gente.', 4),
                  const SizedBox(height: 80), // Espacio para el botón flotante
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add_review'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        icon: const Icon(Icons.rate_review, color: Colors.white),
        label: const Text('Calificar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildReviewTile(String name, String comment, int stars) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(child: Text(name[0])),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Row(children: List.generate(5, (index) => Icon(Icons.star, size: 16, color: index < stars ? Colors.amber : Colors.grey[300]))),
                const SizedBox(height: 5),
                Text(comment, style: TextStyle(color: Colors.grey[800])),
              ],
            ),
          )
        ],
      ),
    );
  }
}