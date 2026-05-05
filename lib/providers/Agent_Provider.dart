import 'package:flutter/material.dart';
import '../models/Agent.dart';
import '../service/ApiService.dart';

class AgentProvider extends ChangeNotifier {
  List<Agent> _allAgent = [];
  bool _isLoading = false;

  List<Agent> get allAgent => _allAgent;
  bool get isLoading => _isLoading;

  AgentProvider() {
    loadAgents();
  }

  // lib/providers/Agent_Provider.dart
  Future<void> loadAgents() async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<Map<String, dynamic>> usersData = await ApiService.getUsers();

      // Explicitly type the list as <Agent>
      _allAgent = usersData.map<Agent>((json) {
        return Agent(
          id: json['id'].toString(),
          name: json['name'] ?? 'Unknown',
          email: json['email'] ?? '',
          image: json['image'] ?? 'assets/images/images.png',
          rating: (json['rating'] ?? 0.0).toDouble(), // Changed from 'rate' to 'rating'
          // Handle property lists from your JSON keys
          listingProperties: (json['listing_properties'] as List? ?? [])
              .map((e) => e.toString())
              .toList(),
          soldProperties: (json['sold_properties'] as List? ?? [])
              .map((e) => e.toString())
              .toList(),
        );
      }).toList();

      // Sort using .rating
      _allAgent.sort((a, b) => b.rating.compareTo(a.rating));

    } catch (e) {
      debugPrint("Error loading agents: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}