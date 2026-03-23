import 'restaurant.dart';
import 'restaurant_availability_slot.dart';

abstract class RestaurantRepository {
  Future<List<Restaurant>> fetchRestaurants();

  Future<List<Restaurant>> fetchOwnedRestaurants(String ownerId);

  Future<Restaurant?> fetchRestaurantById(String restaurantId);

  Future<List<RestaurantAvailabilitySlot>> fetchAvailability({
    required String restaurantId,
    required DateTime date,
  });

  Future<Restaurant> createRestaurant({
    required String ownerId,
    required String name,
    required String cuisine,
    required String location,
    required String address,
    required String openHours,
    required int seatingCapacity,
  });

  Future<Restaurant> updateRestaurant(Restaurant restaurant);
}
