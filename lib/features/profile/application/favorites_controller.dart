import 'package:flutter/foundation.dart';

import '../../auth/application/auth_controller.dart';
import '../domain/favorites_repository.dart';

class FavoritesController extends ChangeNotifier {
  FavoritesController({
    required AuthController authController,
    required FavoritesRepository favoritesRepository,
  })  : _authController = authController,
        _favoritesRepository = favoritesRepository {
    _authController.addListener(_handleAuthChanged);
    _favoritesRepository.addListener(_handleFavoritesChanged);
  }

  final AuthController _authController;
  final FavoritesRepository _favoritesRepository;

  Set<String> _favoriteIds = <String>{};

  Set<String> get favoriteIds => _favoriteIds;

  Future<void> initialize() async {
    await _reload();
  }

  bool isFavorite(String restaurantId) => _favoriteIds.contains(restaurantId);

  Future<void> toggleFavorite(String restaurantId) async {
    final user = _authController.currentUser;
    if (user == null) {
      return;
    }
    await _favoritesRepository.toggleFavorite(
      userId: user.id,
      restaurantId: restaurantId,
    );
  }

  Future<void> _reload() async {
    final user = _authController.currentUser;
    if (user == null) {
      _favoriteIds = <String>{};
    } else {
      _favoriteIds = await _favoritesRepository.fetchFavoriteRestaurantIds(user.id);
    }
    notifyListeners();
  }

  void _handleAuthChanged() {
    _reload();
  }

  void _handleFavoritesChanged() {
    _reload();
  }

  @override
  void dispose() {
    _authController.removeListener(_handleAuthChanged);
    _favoritesRepository.removeListener(_handleFavoritesChanged);
    super.dispose();
  }
}
