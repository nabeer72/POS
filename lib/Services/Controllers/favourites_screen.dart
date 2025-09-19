import 'package:get/get.dart';

class FavoritesController extends GetxController {
  var favoriteItems = <String>[].obs; // List of favorite item titles

  void toggleFavorite(String title) {
    if (favoriteItems.contains(title)) {
      favoriteItems.remove(title);
    } else {
      favoriteItems.add(title);
    }
  }

  bool isFavorite(String title) {
    return favoriteItems.contains(title);
  }
}