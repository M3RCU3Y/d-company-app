import '../../../app/data/mock_app_store.dart';
import '../domain/reservation.dart';
import '../domain/reservation_repository.dart';
import '../domain/reservation_status.dart';

class MockReservationRepository extends ReservationRepository {
  MockReservationRepository(this._store);

  final MockAppStore _store;

  @override
  Future<Reservation> createReservation({
    required String restaurantId,
    required String userId,
    required String userName,
    required int partySize,
    required DateTime dateTime,
    required String note,
  }) async {
    final nextId = (_store.reservations.length + 1).toString().padLeft(3, '0');
    final reservation = Reservation(
      id: 'res-$nextId',
      restaurantId: restaurantId,
      userId: userId,
      userName: userName,
      partySize: partySize,
      dateTime: dateTime,
      status: ReservationStatus.pending,
      note: note,
    );
    _store.reservations.insert(0, reservation);
    notifyListeners();
    return reservation;
  }

  @override
  Future<void> cancelReservation(String reservationId) async {
    final index =
        _store.reservations.indexWhere((reservation) => reservation.id == reservationId);
    if (index == -1) {
      return;
    }

    _store.reservations[index] = _store.reservations[index].copyWith(
      status: ReservationStatus.cancelled,
    );
    notifyListeners();
  }

  @override
  Future<List<Reservation>> fetchReservationsForRestaurant(String restaurantId) async {
    final copy = _store.reservations
        .where((reservation) => reservation.restaurantId == restaurantId)
        .toList();
    copy.sort((left, right) => right.dateTime.compareTo(left.dateTime));
    return copy;
  }

  @override
  Future<List<Reservation>> fetchReservationsForUser(String userId) async {
    final copy =
        _store.reservations.where((reservation) => reservation.userId == userId).toList();
    copy.sort((left, right) => right.dateTime.compareTo(left.dateTime));
    return copy;
  }

  @override
  Future<void> updateReservationStatus({
    required String reservationId,
    required ReservationStatus status,
  }) async {
    final index =
        _store.reservations.indexWhere((reservation) => reservation.id == reservationId);
    if (index == -1) {
      return;
    }

    _store.reservations[index] = _store.reservations[index].copyWith(
      status: status,
    );
    notifyListeners();
  }
}
