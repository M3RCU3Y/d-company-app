import 'package:flutter/foundation.dart';

import '../../auth/application/auth_controller.dart';
import '../../discover/domain/restaurant.dart';
import '../../discover/domain/restaurant_repository.dart';
import '../domain/reservation.dart';
import '../domain/reservation_repository.dart';
import '../domain/reservation_status.dart';

class BookingListItem {
  const BookingListItem({
    required this.restaurant,
    required this.reservation,
  });

  final Restaurant restaurant;
  final Reservation reservation;
}

class BookingsController extends ChangeNotifier {
  BookingsController({
    required ReservationRepository reservationRepository,
    required RestaurantRepository restaurantRepository,
    required AuthController authController,
  })  : _reservationRepository = reservationRepository,
        _restaurantRepository = restaurantRepository,
        _authController = authController {
    _reservationRepository.addListener(_handleRepositoryUpdate);
    _authController.addListener(_handleRepositoryUpdate);
  }

  final ReservationRepository _reservationRepository;
  final RestaurantRepository _restaurantRepository;
  final AuthController _authController;

  bool _isLoading = false;
  List<BookingListItem> _upcoming = const [];
  List<BookingListItem> _history = const [];

  bool get isLoading => _isLoading;
  List<BookingListItem> get upcoming => _upcoming;
  List<BookingListItem> get history => _history;

  Future<void> initialize() async {
    await refresh();
  }

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();

    final restaurants = await _restaurantRepository.fetchRestaurants();
    final user = _authController.currentUser;
    if (user == null) {
      _upcoming = const [];
      _history = const [];
      _isLoading = false;
      notifyListeners();
      return;
    }
    final reservations =
        await _reservationRepository.fetchReservationsForUser(user.id);
    final restaurantsById = {
      for (final restaurant in restaurants) restaurant.id: restaurant,
    };
    final now = DateTime.now();

    final items = reservations
        .where((reservation) => restaurantsById.containsKey(reservation.restaurantId))
        .map(
          (reservation) => BookingListItem(
            restaurant: restaurantsById[reservation.restaurantId]!,
            reservation: reservation,
          ),
        )
        .toList();

    _upcoming = items.where((item) {
      return item.reservation.status != ReservationStatus.cancelled &&
          item.reservation.status != ReservationStatus.completed &&
          item.reservation.dateTime.isAfter(now);
    }).toList();

    _history = items.where((item) {
      return item.reservation.status == ReservationStatus.cancelled ||
          item.reservation.status == ReservationStatus.completed ||
          item.reservation.dateTime.isBefore(now);
    }).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> cancelReservation(String reservationId) async {
    await _reservationRepository.cancelReservation(reservationId);
  }

  void _handleRepositoryUpdate() {
    refresh();
  }

  @override
  void dispose() {
    _reservationRepository.removeListener(_handleRepositoryUpdate);
    _authController.removeListener(_handleRepositoryUpdate);
    super.dispose();
  }
}
