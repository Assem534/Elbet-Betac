class Estate {
  final String id;
  String name;
  String type;
  String location;
  String price;
  String image;
  double rate;
  bool isFav;

  // Extra server fields
  final int? area;
  final int? rooms;
  final int? baths;
  final String? province;
  final String? city;
  final String? furnishingStatus;
  final String? completionStatus;
  final String? ownerId;
  final String? ownerName;

  Estate({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.price,
    required this.image,
    required this.rate,
    this.isFav = false,
    this.area,
    this.rooms,
    this.baths,
    this.province,
    this.city,
    this.furnishingStatus,
    this.completionStatus,
    this.ownerId,
    this.ownerName,
  });

  factory Estate.fromJson(Map<String, dynamic> json) {
    final city = json['city'] as String? ?? '';
    final province = json['province'] as String? ?? '';
    final location = (city.isNotEmpty && province.isNotEmpty)
        ? '$city, $province'
        : city.isNotEmpty
        ? city
        : province;

    return Estate(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? 'Unknown',
      type: json['property_type'] as String? ?? 'Property',
      location: location,
      price: json['price']?.toString() ?? '0',
      image: json['image'] as String? ?? 'assets/images/real_estate.png',
      rate: (json['rate'] as num?)?.toDouble() ?? 4.0,
      area: json['area'] as int?,
      rooms: json['rooms'] as int?,
      baths: json['baths'] as int?,
      province: province,
      city: city,
      furnishingStatus: json['furnishing_status'] as String?,
      completionStatus: json['completion_status'] as String?,
      ownerId: json['owner_id'] as String?,
      ownerName: json['owner_name'] as String?,
    );
  }
}