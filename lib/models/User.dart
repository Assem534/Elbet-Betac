class User {
  final String id;
  final String name;
  final String email;
  final String image;
  final double rating;
  final List<String> listingProperties;
  final List<String> soldProperties;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    required this.rating,
    required this.listingProperties,
    required this.soldProperties,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? 'assets/images/images.png',
      rating: (json['rating'] ?? 0.0).toDouble(),

      // MATCH THESE TO YOUR JSON:
      listingProperties: (json['listing_properties'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      soldProperties: (json['sold_properties'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}