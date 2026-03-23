import '../../../app/data/mock_app_store.dart';
import '../../discover/domain/restaurant.dart';
import '../../restaurant/domain/restaurant_approval_status.dart';
import '../domain/admin_repository.dart';

class MockAdminRepository implements AdminRepository {
  MockAdminRepository(this._store);

  final MockAppStore _store;

  @override
  Future<void> approveRestaurant(String restaurantId) async {
    _updateStatus(restaurantId, RestaurantApprovalStatus.approved);
  }

  @override
  Future<int> fetchApprovedCount() async {
    return _store.restaurants
        .where((restaurant) => restaurant.approvalStatus == RestaurantApprovalStatus.approved)
        .length;
  }

  @override
  Future<List<Restaurant>> fetchPendingRestaurants() async {
    return _store.restaurants
        .where((restaurant) => restaurant.approvalStatus == RestaurantApprovalStatus.pending)
        .toList();
  }

  @override
  Future<void> rejectRestaurant(String restaurantId) async {
    _updateStatus(restaurantId, RestaurantApprovalStatus.rejected);
  }

  void _updateStatus(String restaurantId, RestaurantApprovalStatus status) {
    final index = _store.restaurants.indexWhere((restaurant) => restaurant.id == restaurantId);
    if (index == -1) {
      return;
    }

    _store.restaurants[index] = _store.restaurants[index].copyWith(
      approvalStatus: status,
      nextSlotLabel: status == RestaurantApprovalStatus.approved
          ? 'Accepting requests'
          : 'Pending approval',
    );
  }
}
