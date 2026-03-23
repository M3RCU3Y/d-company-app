import 'reservation_status.dart';

class Reservation {
  const Reservation({
    required this.id,
    required this.restaurantId,
    required this.userId,
    required this.userName,
    required this.partySize,
    required this.dateTime,
    required this.status,
    this.note = '',
  });

  final String id;
  final String restaurantId;
  final String userId;
  final String userName;
  final int partySize;
  final DateTime dateTime;
  final ReservationStatus status;
  final String note;

  Reservation copyWith({
    String? id,
    String? restaurantId,
    String? userId,
    String? userName,
    int? partySize,
    DateTime? dateTime,
    ReservationStatus? status,
    String? note,
  }) {
    return Reservation(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      partySize: partySize ?? this.partySize,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      note: note ?? this.note,
    );
  }
}
