import 'package:flutter/material.dart';
import '../models/User.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  // دالة لتحديث بيانات المستخدم عند تسجيل الدخول
  void setUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }

  // دالة لتسجيل الخروج
  void logout() {
    _user = null;
    notifyListeners();
  }
}