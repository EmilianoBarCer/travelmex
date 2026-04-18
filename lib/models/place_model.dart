class Place {
  final String id;
  final String name;
  final String category;
  final String price;
  final double rating;
  final String imageUrl;
  final String distance;

  Place({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.distance,
  });

  // Esta función es la que "traduce" lo que viene de internet
  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      id: map['id'].toString(),
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      price: map['price'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      imageUrl: map['image_url'] ?? '',
      distance: map['distance'] ?? '',
    );
  }
}