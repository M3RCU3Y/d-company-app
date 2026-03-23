import '../../../app/data/mock_app_store.dart';
import '../domain/restaurant.dart';
import '../domain/restaurant_availability_slot.dart';
import '../domain/restaurant_repository.dart';
import '../../restaurant/domain/restaurant_approval_status.dart';

class MockRestaurantRepository implements RestaurantRepository {
  MockRestaurantRepository(this._store);

  final MockAppStore _store;

  @override
  Future<List<Restaurant>> fetchRestaurants() async {
    return _store.restaurants
        .where((restaurant) => restaurant.approvalStatus == RestaurantApprovalStatus.approved)
        .toList();
  }

  @override
  Future<Restaurant?> fetchRestaurantById(String restaurantId) async {
    for (final restaurant in _store.restaurants) {
      if (restaurant.id == restaurantId) {
        return restaurant;
      }
    }
    return null;
  }

  @override
  Future<List<Restaurant>> fetchOwnedRestaurants(String ownerId) async {
    return _store.restaurants
        .where((restaurant) => restaurant.ownerId == ownerId)
        .toList();
  }

  @override
  Future<List<RestaurantAvailabilitySlot>> fetchAvailability({
    required String restaurantId,
    required DateTime date,
  }) async {
    final base = DateTime(date.year, date.month, date.day);
    final hoursByRestaurant = {
      'estate-101': [18, 20, 21],
      'maracas-tide': [12, 14, 19],
      'cocoa-yard': [17, 19, 21],
    };

    final hours = hoursByRestaurant[restaurantId] ?? [18, 20];
    return Future.value([
      for (var index = 0; index < hours.length; index++)
        RestaurantAvailabilitySlot(
          id: '$restaurantId-${base.toIso8601String()}-$index',
          restaurantId: restaurantId,
          startTime: DateTime(base.year, base.month, base.day, hours[index], index == 1 ? 30 : 0),
          seatsRemaining: 2 + index,
        ),
    ]);
  }

  @override
  Future<Restaurant> createRestaurant({
    required String ownerId,
    required String name,
    required String cuisine,
    required String location,
    required String address,
    required String openHours,
    required int seatingCapacity,
  }) async {
    final restaurant = Restaurant(
      id: 'restaurant-${_store.restaurants.length + 1}',
      name: name,
      ownerId: ownerId,
      location: location,
      address: address,
      cuisine: cuisine,
      priceLevel: '\$\$',
      rating: 0,
      reviewCount: 0,
      description:
          'Freshly onboarded restaurant profile awaiting approval and public launch.',
      heroImage:
          'https://images.unsplash.com/photo-1514933651103-005eec06c04b?auto=format&fit=crop&w=1200&q=80',
      vibe: 'Pending launch setup.',
      openHours: openHours,
      nextSlotLabel: 'Pending approval',
      seatingCapacity: seatingCapacity,
      approvalStatus: RestaurantApprovalStatus.pending,
      tags: ['New'],
    );
    _store.restaurants.add(restaurant);
    return restaurant;
  }

  @override
  Future<Restaurant> updateRestaurant(Restaurant restaurant) async {
    final index = _store.restaurants.indexWhere((item) => item.id == restaurant.id);
    if (index != -1) {
      _store.restaurants[index] = restaurant;
    }
    return restaurant;
  }
}
