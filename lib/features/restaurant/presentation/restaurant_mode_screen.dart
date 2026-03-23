import 'package:flutter/material.dart';

import '../../../app/app_scope.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/presentation/widgets/empty_state.dart';
import '../../../core/presentation/widgets/primary_cta_button.dart';
import '../../../core/presentation/widgets/section_header.dart';
import '../../../core/presentation/widgets/status_badge.dart';
import '../../../core/utils/date_time_formatters.dart';
import '../../bookings/domain/reservation_status.dart';
import '../../restaurant/domain/restaurant_approval_status.dart';

class RestaurantModeScreen extends StatefulWidget {
  const RestaurantModeScreen({super.key});

  @override
  State<RestaurantModeScreen> createState() => _RestaurantModeScreenState();
}

class _RestaurantModeScreenState extends State<RestaurantModeScreen> {
  final nameController = TextEditingController();
  final cuisineController = TextEditingController();
  final locationController = TextEditingController();
  final addressController = TextEditingController();
  final hoursController = TextEditingController(text: 'Tue-Sun · 5:00 PM to 10:00 PM');
  final seatingController = TextEditingController(text: '40');

  @override
  void dispose() {
    nameController.dispose();
    cuisineController.dispose();
    locationController.dispose();
    addressController.dispose();
    hoursController.dispose();
    seatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context).restaurantDashboardController;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Restaurant tools')),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final restaurant = controller.restaurant;

          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (restaurant == null) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              children: [
                const SectionHeader(
                  title: 'Restaurant onboarding',
                  subtitle: 'Create a draft profile for admin review and launch prep.',
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Restaurant name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: cuisineController,
                  decoration: const InputDecoration(labelText: 'Cuisine'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: hoursController,
                  decoration: const InputDecoration(labelText: 'Operating hours'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: seatingController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Seating capacity'),
                ),
                const SizedBox(height: 24),
                PrimaryCtaButton(
                  label: 'Create restaurant draft',
                  onPressed: () async {
                    await controller.createRestaurant(
                      name: nameController.text,
                      cuisine: cuisineController.text,
                      location: locationController.text,
                      address: addressController.text,
                      openHours: hoursController.text,
                      seatingCapacity: int.tryParse(seatingController.text) ?? 40,
                    );
                  },
                ),
              ],
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            children: [
              Text(
                restaurant.name,
                style: theme.textTheme.displaySmall,
              ),
              const SizedBox(height: 10),
              Text(
                '${restaurant.location} · ${restaurant.cuisine}',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Approval status', style: theme.textTheme.bodyLarge),
                    const SizedBox(height: 8),
                    StatusBadge(
                      status: switch (restaurant.approvalStatus) {
                        RestaurantApprovalStatus.pending => ReservationStatus.pending,
                        RestaurantApprovalStatus.approved => ReservationStatus.confirmed,
                        RestaurantApprovalStatus.rejected => ReservationStatus.cancelled,
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const SectionHeader(
                title: 'Operating setup',
                subtitle: 'Basic hours and capacity management for the first restaurant-side MVP.',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: hoursController..text = restaurant.openHours,
                decoration: const InputDecoration(labelText: 'Operating hours'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: seatingController..text = '${restaurant.seatingCapacity}',
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Seating capacity'),
              ),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: () {
                  controller.updateRestaurant(
                    openHours: hoursController.text,
                    seatingCapacity: int.tryParse(seatingController.text) ?? restaurant.seatingCapacity,
                  );
                },
                child: const Text('Save operations'),
              ),
              const SizedBox(height: 24),
              const SectionHeader(
                title: 'Reservation dashboard',
                subtitle: 'Approve or reject requests before they move into service planning.',
              ),
              const SizedBox(height: 14),
              if (controller.pendingReservations.isEmpty &&
                  controller.confirmedReservations.isEmpty &&
                  controller.completedReservations.isEmpty)
                const EmptyState(
                  title: 'No reservation traffic yet.',
                  message: 'Incoming customer requests will show up here once the restaurant is approved and live.',
                  icon: Icons.storefront_outlined,
                )
              else ...[
                _ReservationSection(
                  title: 'Pending',
                  reservations: controller.pendingReservations,
                  onApprove: controller.approveReservation,
                  onReject: controller.rejectReservation,
                ),
                const SizedBox(height: 18),
                _ReservationSection(
                  title: 'Confirmed',
                  reservations: controller.confirmedReservations,
                ),
                const SizedBox(height: 18),
                _ReservationSection(
                  title: 'Completed / Cancelled',
                  reservations: controller.completedReservations,
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _ReservationSection extends StatelessWidget {
  const _ReservationSection({
    required this.title,
    required this.reservations,
    this.onApprove,
    this.onReject,
  });

  final String title;
  final List<dynamic> reservations;
  final Future<void> Function(String reservationId)? onApprove;
  final Future<void> Function(String reservationId)? onReject;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (reservations.isEmpty) {
      return Text('$title: none yet', style: theme.textTheme.bodyLarge);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        for (final reservation in reservations) ...[
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reservation.userName, style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(DateTimeFormatters.bookingDateTime(reservation.dateTime)),
                const SizedBox(height: 6),
                Text('${reservation.partySize} guests'),
                if (reservation.note.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text('Note: ${reservation.note}'),
                ],
                if (onApprove != null || onReject != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (onApprove != null)
                        TextButton(
                          onPressed: () => onApprove!(reservation.id),
                          child: const Text('Approve'),
                        ),
                      if (onReject != null)
                        TextButton(
                          onPressed: () => onReject!(reservation.id),
                          child: const Text('Reject'),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
