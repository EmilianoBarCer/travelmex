import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/place_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // El nombre de tu tabla en Supabase
  final _placesFuture = Supabase.instance.client.from('placesgdl').select();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TravelMex Guadalajara', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      // EL FUTUREBUILDER DEBE IR DENTRO DEL BODY
      body: FutureBuilder(
        future: _placesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data as List<dynamic>;

          if (data.isEmpty) {
            return const Center(child: Text('No hay lugares guardados aún.'));
          }

          final places = data.map((map) => Place.fromMap(map)).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: places.length,
            itemBuilder: (context, index) {
              final place = places[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Image.network(
                      place.imageUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      // Si la imagen falla, muestra un icono de error
                      errorBuilder: (context, error, stackTrace) =>
                          Container(height: 180, color: Colors.grey[300], child: const Icon(Icons.image_not_supported)),
                    ),
                    ListTile(
                      title: Text(place.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${place.category} • ${place.distance}'),
                      trailing: Text(place.price, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add_review'),
        child: const Icon(Icons.add),
      ),
    );
  }
}