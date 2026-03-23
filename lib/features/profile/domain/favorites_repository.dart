import 'package:flutter/foundation.dart';

abstract class FavoritesRepository extends ChangeNotifier {
  Future<Set<String>> fetchFavoriteRestaurantIds(String userId);

  Future<void> toggleFavorite({
    required String userId,
    required String restaurantId,
  });
}
