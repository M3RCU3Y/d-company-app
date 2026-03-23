import 'package:flutter/foundation.dart';

import '../../auth/application/auth_controller.dart';
import '../../bookings/domain/reservation.dart';
import '../../bookings/domain/reservation_repository.dart';
import '../../bookings/domain/reservation_status.dart';
import '../../discover/domain/restaurant.dart';
import '../../discover/domain/restaurant_repository.dart';

class RestaurantDashboardController extends ChangeNotifier {
  RestaurantDashboardController({
    required AuthController authController,
    required RestaurantRepository restaurantRepository,
    required ReservationRepository reservationRepository,
  })  : _authController = authController,
        _restaurantRepository = restaurantRepository,
        _reservationRepository = reservationRepository {
    _authController.addListener(_handleAuthChanged);
    _reservationRepository.addListener(_handleReservationsChanged);
  }

  final AuthController _authController;
  final RestaurantRepository _restaurantRepository;
  final ReservationRepository _reservationRepository;

  Restaurant? _restaurant;
  List<Reservation> _reservations = const [];
  bool _isLoading = false;

  Restaurant? get restaurant => _restaurant;
  bool get isLoading => _isLoading;
  List<Reservation> get pendingReservations => _reservations
      .where((reservation) => reservation.status == ReservationStatus.pending)
      .toList();
  List<Reservation> get confirmedReservations => _reservations
      .where((reservation) => reservation.status == ReservationStatus.confirmed)
      .toList();
  List<Reservation> get completedReservations => _reservations
      .where((reservation) =>
          reservation.status == ReservationStatus.completed ||
          reservation.status == ReservationStatus.cancelled)
      .toList();

  Future<void> initialize() async {
    await _loadOwnedRestaurant();
  }

  Future<void> createRestaurant({
    required String name,
    required String cuisine,
    required String location,
    required String address,
    required String openHours,
    required int seatingCapacity,
  }) async {
    final user = _authController.currentUser;
    if (user == null) {
      return;
    }

    _restaurant = await _restaurantRepository.createRestaurant(
      ownerId: user.id,
      name: name,
      cuisine: cuisine,
      location: location,
      address: address,
      openHours: openHours,
      seatingCapacity: seatingCapacity,
    );
    await _refreshReservations();
    notifyListeners();
  }

  Future<void> updateRestaurant({
    required String openHours,
    required int seatingCapacity,
  }) async {
    final current = _restaurant;
    if (current == null) {
      return;
    }

    _restaurant = await _restaurantRepository.updateRestaurant(
      current.copyWith(
        openHours: openHours,
        seatingCapacity: seatingCapacity,
      ),
    );
    notifyListeners();
  }

  Future<void> approveReservation(String reservationId) async {
    await _reservationRepository.updateReservationStatus(
      reservationId: reservationId,
      status: ReservationStatus.confirmed,
    );
  }

  Future<void> rejectReservation(String reservationId) async {
    await _reservationRepository.updateReservationStatus(
      reservationId: reservationId,
      status: ReservationStatus.cancelled,
    );
  }

  Future<void> _loadOwnedRestaurant() async {
    _isLoading = true;
    notifyListeners();
    final user = _authController.currentUser;
    if (user == null) {
      _restaurant = null;
      _reservations = const [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    final owned = await _restaurantRepository.fetchOwnedRestaurants(user.id);
    _restaurant = owned.isEmpty ? null : owned.first;
    await _refreshReservations();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _refreshReservations() async {
    final current = _restaurant;
    if (current == null) {
      _reservations = const [];
      notifyListeners();
      return;
    }

    _reservations =
        await _reservationRepository.fetchReservationsForRestaurant(current.id);
    notifyListeners();
  }

  @override
  void dispose() {
    _authController.removeListener(_handleAuthChanged);
    _reservationRepository.removeListener(_handleReservationsChanged);
    super.dispose();
  }

  void _handleAuthChanged() {
    _loadOwnedRestaurant();
  }

  void _handleReservationsChanged() {
    _refreshReservations();
  }
}
