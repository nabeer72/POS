import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_keychain/flutter_keychain.dart';

class FavoritesController extends GetxController {
  var favoriteActions = <String>[].obs;

  static const _storageKey = "favorite_actions";

  @override
  void onInit() {
    super.onInit();
    _loadFavorites(); // 🔹 App start pe saved favorites load
  }

  Future<void> addFavorite(String action) async {
    if (!favoriteActions.contains(action)) {
      favoriteActions.add(action);
      await _saveFavorites(); // 🔹 Save after add
    }
  }

  Future<void> removeFavorite(String action) async {
    favoriteActions.remove(action);
    await _saveFavorites(); // 🔹 Save after remove
  }

  /// 🔹 Save list to flutter_keychain
  Future<void> _saveFavorites() async {
    try {
      final jsonString = jsonEncode(favoriteActions.toList());
      await FlutterKeychain.put(key: _storageKey, value: jsonString);
    } catch (e) {
      print("Error saving favorites: $e");
    }
  }

  /// 🔹 Load list from flutter_keychain
  Future<void> _loadFavorites() async {
    try {
      final jsonString = await FlutterKeychain.get(key: _storageKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> data = jsonDecode(jsonString);
        favoriteActions.assignAll(data.map((e) => e.toString()));
      }
    } catch (e) {
      print("Error loading favorites: $e");
    }
  }
}
