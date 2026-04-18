import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200'),
              ),
            ),
            const SizedBox(height: 15),
            const Text('Emiliano', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const Text('Nivel 4 - Viajero de Corazón', style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w600)),
            const SizedBox(height: 30),
            _infoRow(Icons.phone, '+52 555 123 4567'),
            _infoRow(Icons.email, 'emiliano@travelmex.com'),
            _infoRow(Icons.location_on, 'Ciudad de México, México'),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Tus Opiniones', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(Icons.restaurant, color: Colors.deepOrange),
                title: const Text('Tacos El Compadre'),
                subtitle: const Text('¡Riquísimos!'),
                trailing: const Icon(Icons.star, color: Colors.amber),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 15),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}