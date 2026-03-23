class NotificationPreference {
  const NotificationPreference({
    required this.reservationUpdatesEnabled,
    required this.savedRestaurantAlertsEnabled,
  });

  final bool reservationUpdatesEnabled;
  final bool savedRestaurantAlertsEnabled;

  NotificationPreference copyWith({
    bool? reservationUpdatesEnabled,
    bool? savedRestaurantAlertsEnabled,
  }) {
    return NotificationPreference(
      reservationUpdatesEnabled:
          reservationUpdatesEnabled ?? this.reservationUpdatesEnabled,
      savedRestaurantAlertsEnabled:
          savedRestaurantAlertsEnabled ?? this.savedRestaurantAlertsEnabled,
    );
  }
}
