import 'package:flutter/foundation.dart';

import '../domain/restaurant.dart';
import '../domain/restaurant_filter_state.dart';
import '../domain/restaurant_repository.dart';

class DiscoverController extends ChangeNotifier {
  DiscoverController({
    required RestaurantRepository restaurantRepository,
  }) : _restaurantRepository = restaurantRepository;

  final RestaurantRepository _restaurantRepository;

  static const filterOptions = [
    'All',
    'Trending',
    'Date Night',
    'Seafood',
    'Groups',
  ];

  bool _isLoading = false;
  List<Restaurant> _restaurants = const [];
  RestaurantFilterState _filters = const RestaurantFilterState();

  bool get isLoading => _isLoading;
  RestaurantFilterState get filters => _filters;

  List<Restaurant> get restaurants {
    final query = _filters.query.trim().toLowerCase();

    return _restaurants.where((restaurant) {
      final matchesCategory = _filters.selectedCategory == 'All' ||
          restaurant.tags.any(
            (tag) => tag.toLowerCase().contains(_filters.selectedCategory.toLowerCase()),
          ) ||
          restaurant.cuisine.toLowerCase().contains(_filters.selectedCategory.toLowerCase()) ||
          restaurant.vibe.toLowerCase().contains(_filters.selectedCategory.toLowerCase());

      final matchesQuery = query.isEmpty ||
          restaurant.name.toLowerCase().contains(query) ||
          restaurant.cuisine.toLowerCase().contains(query) ||
          restaurant.location.toLowerCase().contains(query) ||
          restaurant.address.toLowerCase().contains(query);

      return matchesCategory && matchesQuery;
    }).toList();
  }

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    _restaurants = await _restaurantRepository.fetchRestaurants();
    _isLoading = false;
    notifyListeners();
  }

  void setQuery(String value) {
    _filters = _filters.copyWith(query: value);
    notifyListeners();
  }

  void setCategory(String value) {
    _filters = _filters.copyWith(selectedCategory: value);
    notifyListeners();
  }
}
