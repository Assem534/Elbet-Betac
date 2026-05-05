import 'dart:convert';
import 'package:http/http.dart' as http;

const String _jsonServerUrl = 'http://10.0.2.2:3000';
const String _bayutApiUrl = 'http://10.0.2.2:8000';

class ApiService {
  static Future<void> updateUser(String userId, Map<String, dynamic> fields) async {
    await http.patch(
      Uri.parse('$_jsonServerUrl/users/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(fields),
    );
  }


  static Future<void> addUserProperty(
    String userId,
    List<String> propertyIds,
  ) async {
    await http.patch(
      Uri.parse('$_jsonServerUrl/users/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'my_properties': propertyIds}),
    );
  }

  static Future<void> addEstate(Map<String, dynamic> estateData) async {
    // Use properties to match your data.json key
    final url = Uri.parse('$_jsonServerUrl/properties');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(estateData),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Server error: ${response.body}');
      }
    } catch (e) {
      print("API Error: $e");
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getUsers() async {
    final res = await http.get(Uri.parse('$_jsonServerUrl/users'));
    if (res.statusCode == 200) {
      List<dynamic> data = jsonDecode(res.body);
      return List<Map<String, dynamic>>.from(data);
    }
    throw Exception('Failed to load users');
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$_jsonServerUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200) return body['user'] as Map<String, dynamic>;
    throw Exception(body['error'] ?? 'Login failed');
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$_jsonServerUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 201) return body['user'] as Map<String, dynamic>;
    throw Exception(body['error'] ?? 'Registration failed');
  }

  static Future<List<Map<String, dynamic>>> getProperties() async {
    final res = await http.get(Uri.parse('$_jsonServerUrl/properties'));
    if (res.statusCode == 200)
      return (jsonDecode(res.body) as List).cast<Map<String, dynamic>>();
    throw Exception('Failed to load properties');
  }

  static Future<Map<String, dynamic>> getUserById(String userId) async {
    final res = await http.get(Uri.parse('$_jsonServerUrl/users/$userId'));
    if (res.statusCode == 200)
      return jsonDecode(res.body) as Map<String, dynamic>;
    throw Exception('User not found');
  }

  static Future<void> updateFavorites(
    String userId,
    List<String> favoriteIds,
  ) async {
    await http.patch(
      Uri.parse('$_jsonServerUrl/users/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'favorites': favoriteIds}),
    );
  }

  static Future<void> syncUserFavorites(
    String userId,
    List<String> favoriteIds,
  ) async {
    final res = await http.patch(
      Uri.parse('$_jsonServerUrl/users/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'favorites': favoriteIds}),
    );
    if (res.statusCode != 200) throw Exception('Failed to sync favorites');
  }

  static Future<List<Map<String, dynamic>>> getReviews() async {
    final res = await http.get(Uri.parse('$_jsonServerUrl/reviews'));
    if (res.statusCode == 200)
      return (jsonDecode(res.body) as List).cast<Map<String, dynamic>>();
    throw Exception('Failed to load reviews');
  }

  // ── BAYUT ML PRICE PREDICTION ──────────────────────────────────────────
  static Future<PricePrediction> predictPrice(
    PropertyPredictRequest req,
  ) async {
    final res = await http.post(
      Uri.parse('$_bayutApiUrl/predict'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(req.toJson()),
    );
    if (res.statusCode == 200)
      return PricePrediction.fromJson(
        jsonDecode(res.body) as Map<String, dynamic>,
      );
    final err = jsonDecode(res.body);
    throw Exception(err['detail'] ?? 'Prediction failed');
  }

  static Future<Map<String, dynamic>> getBayutConstants() async {
    final res = await http.get(Uri.parse('$_bayutApiUrl/constants'));
    if (res.statusCode == 200)
      return jsonDecode(res.body) as Map<String, dynamic>;
    throw Exception('Failed to load constants');
  }
}

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

class PricePrediction {
  final int predictedPrice, priceRangeLow, priceRangeHigh;
  final String currency, confidence;

  PricePrediction({
    required this.predictedPrice,
    required this.priceRangeLow,
    required this.priceRangeHigh,
    required this.currency,
    required this.confidence,
  });

  factory PricePrediction.fromJson(Map<String, dynamic> j) => PricePrediction(
    predictedPrice: j['predicted_price'] as int,
    priceRangeLow: j['price_range_low'] as int,
    priceRangeHigh: j['price_range_high'] as int,
    currency: j['currency'] as String,
    confidence: j['confidence'] as String,
  );

  String _fmt(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}K';
    return n.toString();
  }

  String get formattedPrice => _fmt(predictedPrice);

  String get formattedRange =>
      '${_fmt(priceRangeLow)} – ${_fmt(priceRangeHigh)} $currency';
}
