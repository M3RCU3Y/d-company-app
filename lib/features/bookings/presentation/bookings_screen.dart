import 'package:flutter/material.dart';

import '../../../app/app_scope.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/presentation/widgets/empty_state.dart';
import '../../../core/presentation/widgets/section_header.dart';
import '../../../core/presentation/widgets/status_badge.dart';
import '../../../core/utils/date_time_formatters.dart';
import '../application/bookings_controller.dart';
import '../domain/reservation_status.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  var selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = AppScope.of(context).bookingsController;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final items = selectedTab == 0 ? controller.upcoming : controller.history;

        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            children: [
              Text(
                'Bookings',
                style: theme.textTheme.displaySmall,
              ),
              const SizedBox(height: 10),
              Text(
                'Manage upcoming reservation requests and track everything that has already happened.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              _BookingOverviewCard(
                upcomingCount: controller.upcoming.length,
                historyCount: controller.history.length,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _BookingTabButton(
                      label: 'Upcoming',
                      selected: selectedTab == 0,
                      onTap: () => setState(() => selectedTab = 0),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _BookingTabButton(
                      label: 'Past',
                      selected: selectedTab == 1,
                      onTap: () => setState(() => selectedTab = 1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SectionHeader(
                title: selectedTab == 0 ? 'Upcoming bookings' : 'Booking history',
                subtitle: selectedTab == 0
                    ? 'Pending and confirmed reservations still on the calendar.'
                    : 'Completed or cancelled reservations move here.',
              ),
              const SizedBox(height: 18),
              if (controller.isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 48),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (items.isEmpty)
                EmptyState(
                  title: selectedTab == 0
                      ? 'No active bookings yet.'
                      : 'No booking history yet.',
                  message: selectedTab == 0
                      ? 'Create a reservation from Discover and it will show up here.'
                      : 'Completed and cancelled reservations will show up once activity starts.',
                  icon: selectedTab == 0
                      ? Icons.event_busy_rounded
                      : Icons.history_toggle_off_rounded,
                )
              else
                for (final item in items) ...[
                  _BookingCard(
                    item: item,
                    onCancel: item.reservation.status == ReservationStatus.pending ||
                            item.reservation.status == ReservationStatus.confirmed
                        ? () => _confirmCancellation(context, controller, item)
                        : null,
                  ),
                  const SizedBox(height: 16),
                ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmCancellation(
    BuildContext context,
    BookingsController controller,
    BookingListItem item,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel reservation?'),
        content: Text(
          'This will move ${item.restaurant.name} to your history and mark the reservation as cancelled.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep booking'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cancel booking'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await controller.cancelReservation(item.reservation.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item.restaurant.name} was cancelled.')),
        );
      }
    }
  }
}

class _BookingOverviewCard extends StatelessWidget {
  const _BookingOverviewCard({
    required this.upcomingCount,
    required this.historyCount,
  });

  final int upcomingCount;
  final int historyCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Expanded(
            child: _BookingMetric(
              label: 'Live bookings',
              value: '$upcomingCount',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _BookingMetric(
              label: 'Past activity',
              value: '$historyCount',
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingMetric extends StatelessWidget {
  const _BookingMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: theme.textTheme.displaySmall?.copyWith(fontSize: 28)),
        const SizedBox(height: 6),
        Text(label, style: theme.textTheme.bodyLarge),
      ],
    );
  }
}

class _BookingTabButton extends StatelessWidget {
  const _BookingTabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.charcoal : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: selected ? AppColors.charcoal : AppColors.line),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.charcoal,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({
    required this.item,
    this.onCancel,
  });

  final BookingListItem item;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.restaurant.name, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 6),
                    Text(
                      '${item.restaurant.location} · ${item.restaurant.cuisine}',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              StatusBadge(status: item.reservation.status),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            DateTimeFormatters.bookingDateTime(item.reservation.dateTime),
            style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            '${item.reservation.partySize} guests',
            style: theme.textTheme.bodyLarge,
          ),
          if (item.reservation.note.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Note: ${item.reservation.note}',
              style: theme.textTheme.bodyLarge,
            ),
          ],
          const SizedBox(height: 18),
          Row(
            children: [
              if (onCancel != null)
                TextButton(
                  onPressed: onCancel,
                  child: const Text('Cancel'),
                ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: null,
                child: const Text('Modify soon'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
