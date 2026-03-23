import '../../../app/data/mock_app_store.dart';
import '../domain/favorites_repository.dart';

class MockFavoritesRepository extends FavoritesRepository {
  MockFavoritesRepository(this._store);

  final MockAppStore _store;

  @override
  Future<Set<String>> fetchFavoriteRestaurantIds(String userId) async {
    return Set<String>.from(_store.favoriteRestaurantIds[userId] ?? <String>{});
  }

  @override
  Future<void> toggleFavorite({
    required String userId,
    required String restaurantId,
  }) async {
    final current = _store.favoriteRestaurantIds.putIfAbsent(userId, () => <String>{});
    if (!current.add(restaurantId)) {
      current.remove(restaurantId);
    }
    notifyListeners();
  }
}
