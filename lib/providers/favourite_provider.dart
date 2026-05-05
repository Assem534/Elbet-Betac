import 'package:flutter/material.dart';
import '../models/estate_request.dart';
import '../service/ApiService.dart';
import 'estate_provider.dart';

class FavouriteProvider extends ChangeNotifier {
  List<Estate> _favourites = [];

  List<Estate> get favourites => _favourites;

  bool isFavourite(Estate estate) {
    return _favourites.any((item) => item.id == estate.id);
  }


  void toggleFavourite(Estate estate, String userId, EstateProvider estateProvider) async {
    final isExist = _favourites.any((item) => item.id == estate.id);

    if (isExist) {
      // 1. الحذف من القائمة المحلية
      _favourites.removeWhere((item) => item.id == estate.id);
      estateProvider.setFavoriteStatus(estate, false);
    } else {
      // 2. الإضافة للقائمة المحلية
      _favourites.add(estate);
      estateProvider.setFavoriteStatus(estate, true);
    }

    notifyListeners();

    // 3. تحديث السيرفر (نرسل مصفوفة الـ IDs فقط)
    try {
      List<String> favIds = _favourites.map((e) => e.id).toList();
      await ApiService.updateFavorites(userId, favIds);
    } catch (e) {
      print("Error syncing with server: $e");
    }
  }
  void updateListFromEstate(Estate estate, String userId) async {
    final index = _favourites.indexWhere((item) => item.id == estate.id);

    if (index != -1) {
      _favourites.removeAt(index);
    } else {
      _favourites.add(estate);
    }

    notifyListeners();

    List<String> favIds = _favourites.map((e) => e.id).toList();
    await ApiService.syncUserFavorites(userId, favIds);
  }

  void removeAt(int index, EstateProvider estateProvider) {
    Estate estate = _favourites[index];

    _favourites.removeAt(index);

    estateProvider.setFavoriteStatus(estate, false);

    notifyListeners();
  }

  // inside favourite_provider.dart

  Future<void> clearAll(EstateProvider estateProvider, String userId) async {
    _favourites.clear();

    estateProvider.resetAllFavorites();
    notifyListeners();

    try {
      await ApiService.updateFavorites(userId, []);
      print("All favorites cleared from server");
    } catch (e) {
      print("Error clearing favorites on server: $e");
    }
  }
}