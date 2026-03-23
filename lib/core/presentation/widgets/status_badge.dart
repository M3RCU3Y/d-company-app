import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../features/bookings/domain/reservation_status.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.status,
  });

  final ReservationStatus status;

  @override
  Widget build(BuildContext context) {
    final palette = switch (status) {
      ReservationStatus.pending => (AppColors.gold, AppColors.charcoal, 'Pending'),
      ReservationStatus.confirmed => (const Color(0xFFDDF5E4), const Color(0xFF196B35), 'Confirmed'),
      ReservationStatus.cancelled => (const Color(0xFFFBE3E3), const Color(0xFFA23838), 'Cancelled'),
      ReservationStatus.completed => (AppColors.soft, AppColors.slate, 'Completed'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: palette.$1,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        palette.$3,
        style: TextStyle(
          color: palette.$2,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
