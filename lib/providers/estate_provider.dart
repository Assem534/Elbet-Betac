import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/Review.dart';
import '../models/estate_request.dart';
import '../service/ApiService.dart';
import 'favourite_provider.dart';

class EstateProvider extends ChangeNotifier {
  List<Estate> _allEstates = [];

  List<Estate> _filteredEstates = [];
  String _searchQuery = '';
  bool _isLoading = false;
  String? _error;

  List<Estate> get estates => _filteredEstates;
  List<Estate> get allEstates => _allEstates;
  bool get isLoading => _isLoading;
  String? get error => _error;

  EstateProvider() {
    loadEstates();
  }


  void _applySearch() {
    _filteredEstates = _searchQuery.isEmpty
        ? List.from(_allEstates)
        : _allEstates
        .where((e) =>
    e.name.toLowerCase().contains(_searchQuery) ||
        e.location.toLowerCase().contains(_searchQuery) ||
        e.type.toLowerCase().contains(_searchQuery))
        .toList();
  }


  void toggleFavourite(Estate estate, FavouriteProvider favProvider, String userId) {
    favProvider.toggleFavourite(estate, userId, this);
  }

  void setFavoriteStatus(Estate estate, bool status) {
    estate.isFav = status;
    notifyListeners();
  }

  void resetAllFavorites() {
    for (var item in _allEstates) {
      item.isFav = false;
    }
    notifyListeners();
  }

  void searchEstates(String query) {
    _searchQuery = query.toLowerCase();
    _applySearch();
    notifyListeners();
  }

  String formatPrice(String price) {
    try {
      double priceValue = double.parse(price);
      final formatter = NumberFormat('#,###');
      return formatter.format(priceValue);
    } catch (e) {
      return price;
    }
  }

  List<Map<String, dynamic>> _allProperties = [];
  List<Map<String, dynamic>> _allReviews = [];

  List<Map<String, dynamic>> get allProperties => _allProperties;

  Future<void> loadInitialData() async {
    _allProperties = await ApiService.getProperties();
    _allReviews = await ApiService.getReviews();
    notifyListeners();
  }


  Future<void> loadEstates() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await ApiService.getProperties();
      _allEstates = data.map((json) => Estate.fromJson(json)).toList();
      _allProperties = data;
      _allReviews = await ApiService.getReviews();
      _applySearch();
    } catch (e) {
      _error = 'Error loading data: $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadReviews() async {
    try {
      _allReviews = await ApiService.getReviews();
      notifyListeners();
    } catch (_) {}
  }

  List<Estate> getPropertiesByIds(List<String> ids) {
    if (ids.isEmpty) return [];
    final idSet = ids.toSet();
    return _allEstates.where((estate) => idSet.contains(estate.id.toString())).toList();
  }

  List<Map<String, dynamic>> getUserReviews(String userId) {
    return _allReviews.where((review) => review['agentId'].toString() == userId).toList();
  }

  List<Review> getReviewsForProperty(String propertyId) {
    return _allReviews
        .where((json) => json['propertyId'].toString() == propertyId)
        .map((json) => Review.fromJson(json))
        .toList();
  }
}