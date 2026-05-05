// lib/models/Agent.dart
class Agent {
  final String id;
  final String name;
  final String email;
  final String image;
  final double rating; // Stick to 'rating' to match your build methods
  final List<String> listingProperties;
  final List<String> soldProperties;

  Agent({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    required this.rating,
    required this.listingProperties,
    required this.soldProperties,
  });
}