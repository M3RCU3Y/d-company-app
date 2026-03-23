import 'package:flutter/foundation.dart';

import '../../auth/application/auth_controller.dart';
import '../../discover/domain/restaurant.dart';
import '../../discover/domain/restaurant_availability_slot.dart';
import '../../discover/domain/restaurant_repository.dart';
import '../domain/reservation_repository.dart';

class ReservationController extends ChangeNotifier {
  ReservationController({
    required this.restaurant,
    required RestaurantRepository restaurantRepository,
    required ReservationRepository reservationRepository,
    required AuthController authController,
  })  : _restaurantRepository = restaurantRepository,
        _reservationRepository = reservationRepository,
        _authController = authController {
    selectedDate = DateTime.now();
    loadAvailability();
  }

  final Restaurant restaurant;
  final RestaurantRepository _restaurantRepository;
  final ReservationRepository _reservationRepository;
  final AuthController _authController;

  late DateTime selectedDate;
  List<RestaurantAvailabilitySlot> availableSlots = const [];
  RestaurantAvailabilitySlot? selectedSlot;
  int guestCount = 2;
  String note = '';
  bool isLoadingSlots = false;
  bool isSubmitting = false;
  String? errorText;

  Future<void> loadAvailability() async {
    isLoadingSlots = true;
    selectedSlot = null;
    notifyListeners();

    availableSlots = await _restaurantRepository.fetchAvailability(
      restaurantId: restaurant.id,
      date: selectedDate,
    );

    isLoadingSlots = false;
    notifyListeners();
  }

  Future<void> selectDate(DateTime value) async {
    selectedDate = value;
    await loadAvailability();
  }

  void selectSlot(RestaurantAvailabilitySlot slot) {
    selectedSlot = slot;
    errorText = null;
    notifyListeners();
  }

  void incrementGuests() {
    if (guestCount == 12) {
      return;
    }
    guestCount += 1;
    errorText = null;
    notifyListeners();
  }

  void decrementGuests() {
    if (guestCount == 1) {
      return;
    }
    guestCount -= 1;
    errorText = null;
    notifyListeners();
  }

  void updateNote(String value) {
    note = value;
    errorText = null;
  }

  void applySuggestedNote(String value) {
    if (note.contains(value)) {
      return;
    }

    if (note.trim().isEmpty) {
      note = value;
    } else {
      note = '${note.trim()} • $value';
    }
    errorText = null;
    notifyListeners();
  }

  Future<bool> submit() async {
    if (selectedSlot == null) {
      errorText = 'Choose a reservation time before sending your request.';
      notifyListeners();
      return false;
    }

    isSubmitting = true;
    errorText = null;
    notifyListeners();

    await _reservationRepository.createReservation(
      restaurantId: restaurant.id,
      userId: _authController.currentUser!.id,
      userName: _authController.currentUser!.displayName,
      partySize: guestCount,
      dateTime: selectedSlot!.startTime,
      note: note.trim(),
    );

    isSubmitting = false;
    notifyListeners();
    return true;
  }
}
