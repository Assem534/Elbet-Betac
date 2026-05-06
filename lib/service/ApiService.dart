import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_real_estate/models/PricePrediction.dart';
import 'package:smart_real_estate/models/PropertyPredictRequest.dart';
import 'package:smart_real_estate/models/estate_request.dart';

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


