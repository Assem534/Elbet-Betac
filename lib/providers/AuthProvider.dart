import 'package:flutter/material.dart';
import '../service/ApiService.dart';

class AuthProvider extends ChangeNotifier {
  Map<String, dynamic>? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  String? get errorMessage => _errorMessage;

  String get userName => _currentUser?['name'] ?? 'Guest';
  String get userEmail => _currentUser?['email'] ?? '';
  String get userImage => _currentUser?['image'] ?? 'assets/images/top_Agent/Shape-1.png';
  String get userId => _currentUser?['id'] ?? '';
  List<String> get userFavorites =>
      List<String>.from(_currentUser?['favorites'] ?? []);

  List<String> _userProperties = [];
  List<String> get userProperties => _userProperties;
  void updateUserProperties(List<String> newList) {
    _userProperties = newList;
    notifyListeners();
  }
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await ApiService.login(email: email, password: password);
      _currentUser = user;

      _userProperties = List<String>.from(user['my_properties'] ?? []);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  //register

  Future<bool> register(String name, String email, String password) async {
    try {
      final user = await ApiService.register(name: name, email: email, password: password);
      _currentUser = user;

      _userProperties = List<String>.from(user['my_properties'] ?? []);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }


  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}