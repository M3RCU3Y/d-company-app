class RestaurantAvailabilitySlot {
  const RestaurantAvailabilitySlot({
    required this.id,
    required this.restaurantId,
    required this.startTime,
    required this.seatsRemaining,
  });

  final String id;
  final String restaurantId;
  final DateTime startTime;
  final int seatsRemaining;
}
