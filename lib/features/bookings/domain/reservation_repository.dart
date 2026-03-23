import 'package:flutter/foundation.dart';

import 'reservation.dart';
import 'reservation_status.dart';

abstract class ReservationRepository extends ChangeNotifier {
  Future<List<Reservation>> fetchReservationsForUser(String userId);

  Future<List<Reservation>> fetchReservationsForRestaurant(String restaurantId);

  Future<Reservation> createReservation({
    required String restaurantId,
    required String userId,
    required String userName,
    required int partySize,
    required DateTime dateTime,
    required String note,
  });

  Future<void> cancelReservation(String reservationId);

  Future<void> updateReservationStatus({
    required String reservationId,
    required ReservationStatus status,
  });
}
