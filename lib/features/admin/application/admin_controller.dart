import 'package:flutter/foundation.dart';

import '../../discover/domain/restaurant.dart';
import '../domain/admin_repository.dart';

class AdminController extends ChangeNotifier {
  AdminController({
    required AdminRepository adminRepository,
  }) : _adminRepository = adminRepository;

  final AdminRepository _adminRepository;

  List<Restaurant> _pendingRestaurants = const [];
  int _approvedCount = 0;
  bool _isLoading = false;

  List<Restaurant> get pendingRestaurants => _pendingRestaurants;
  int get approvedCount => _approvedCount;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    await refresh();
  }

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();
    _pendingRestaurants = await _adminRepository.fetchPendingRestaurants();
    _approvedCount = await _adminRepository.fetchApprovedCount();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> approveRestaurant(String restaurantId) async {
    await _adminRepository.approveRestaurant(restaurantId);
    await refresh();
  }

  Future<void> rejectRestaurant(String restaurantId) async {
    await _adminRepository.rejectRestaurant(restaurantId);
    await refresh();
  }
}
