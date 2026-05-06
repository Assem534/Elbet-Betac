class PropertyPredictRequest {
  final double area;
  final int rooms;
  final int baths;
  final String province;
  final String city;
  final String propertyType;
  final String furnishingStatus;
  final String completionStatus;
  final bool hasSwimmingPool, hasGym, hasCoveredParking, hasGarden;
  final bool hasSecurity, hasBalcony, hasJacuzzi, hasSauna, hasCctv;
  final double lat, lng;

  PropertyPredictRequest({
    required this.area,
    required this.rooms,
    required this.baths,
    required this.province,
    required this.city,
    required this.propertyType,
    this.furnishingStatus = 'unfurnished',
    this.completionStatus = 'completed',
    this.hasSwimmingPool = false,
    this.hasGym = false,
    this.hasCoveredParking = false,
    this.hasGarden = false,
    this.hasSecurity = false,
    this.hasBalcony = false,
    this.hasJacuzzi = false,
    this.hasSauna = false,
    this.hasCctv = false,
    this.lat = 30.0,
    this.lng = 31.0,
  });

  Map<String, dynamic> toJson() => {
    'area': area,
    'rooms': rooms,
    'baths': baths,
    'province': province,
    'city': city,
    'property_type': propertyType,
    'furnishing_status': furnishingStatus,
    'completion_status': completionStatus,
    'has_swimming_pool': hasSwimmingPool,
    'has_gym': hasGym,
    'has_covered_parking': hasCoveredParking,
    'has_garden': hasGarden,
    'has_security': hasSecurity,
    'has_balcony': hasBalcony,
    'has_jacuzzi': hasJacuzzi,
    'has_sauna': hasSauna,
    'has_cctv': hasCctv,
    'lat': lat,
    'lng': lng,
  };
}
