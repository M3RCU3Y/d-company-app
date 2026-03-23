import '../../discover/domain/restaurant.dart';

abstract class AdminRepository {
  Future<List<Restaurant>> fetchPendingRestaurants();

  Future<void> approveRestaurant(String restaurantId);

  Future<void> rejectRestaurant(String restaurantId);

  Future<int> fetchApprovedCount();
}
