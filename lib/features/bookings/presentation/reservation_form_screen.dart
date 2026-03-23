import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/presentation/widgets/primary_cta_button.dart';
import '../../../core/presentation/widgets/section_header.dart';
import '../../../core/utils/date_time_formatters.dart';
import '../../auth/application/auth_controller.dart';
import '../../discover/domain/restaurant.dart';
import '../../discover/domain/restaurant_repository.dart';
import '../application/reservation_controller.dart';
import '../domain/reservation_repository.dart';

class ReservationFormScreen extends StatefulWidget {
  const ReservationFormScreen({
    super.key,
    required this.restaurant,
    required this.restaurantRepository,
    required this.reservationRepository,
    required this.authController,
  });

  final Restaurant restaurant;
  final RestaurantRepository restaurantRepository;
  final ReservationRepository reservationRepository;
  final AuthController authController;

  @override
  State<ReservationFormScreen> createState() => _ReservationFormScreenState();
}

class _ReservationFormScreenState extends State<ReservationFormScreen> {
  static const _suggestedNotes = [
    'Birthday dinner',
    'Window seat',
    'Quiet table',
    'Accessibility support',
  ];

  late final ReservationController controller;
  late final TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    controller = ReservationController(
      restaurant: widget.restaurant,
      restaurantRepository: widget.restaurantRepository,
      reservationRepository: widget.reservationRepository,
      authController: widget.authController,
    );
    noteController = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Reserve a table')),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final selectedSlot = controller.selectedSlot;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
            children: [
            Text(
              widget.restaurant.name,
              style: theme.textTheme.displaySmall,
            ),
            const SizedBox(height: 10),
            Text(
              'Choose a day, claim a time slot, and send the restaurant a clean request.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _ReservationSnapshot(
              restaurant: widget.restaurant,
              guestCount: controller.guestCount,
              selectedDate: controller.selectedDate,
              selectedSlotLabel: selectedSlot == null
                  ? 'Choose a time slot'
                  : DateTimeFormatters.shortTime(selectedSlot.startTime),
            ),
            const SizedBox(height: 24),
            const SectionHeader(
              title: 'Pick a date',
              subtitle: 'Start with a day that works for your group.',
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(4, (index) {
                  final date = DateTime.now().add(Duration(days: index));
                  final selected = DateTimeFormatters.isSameDate(
                    date,
                    controller.selectedDate,
                  );
                  return Padding(
                    padding: EdgeInsets.only(right: index == 3 ? 0 : 10),
                    child: _DateChoicePill(
                      dateLabel: DateTimeFormatters.shortDate(date),
                      selected: selected,
                      onTap: () => controller.selectDate(date),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(
              title: 'Choose a time',
              subtitle: 'Available slots update for the selected date.',
            ),
            const SizedBox(height: 12),
            if (controller.isLoadingSlots)
              const Center(child: CircularProgressIndicator())
            else if (controller.availableSlots.isEmpty)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.line),
                ),
                child: Text(
                  'No slots are available for this day yet. Try the next date or a different restaurant.',
                  style: theme.textTheme.bodyLarge,
                ),
              )
            else
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: controller.availableSlots.map((slot) {
                  final selected = controller.selectedSlot?.id == slot.id;
                  return ChoiceChip(
                    label: Text(
                      '${DateTimeFormatters.shortTime(slot.startTime)} · ${slot.seatsRemaining} seats left',
                    ),
                    selected: selected,
                    onSelected: (_) => controller.selectSlot(slot),
                  );
                }).toList(),
              ),
            const SizedBox(height: 24),
            const SectionHeader(
              title: 'Party size',
              subtitle: 'Adjust the booking size before sending the request.',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.line),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: controller.decrementGuests,
                    icon: const Icon(Icons.remove_circle_outline_rounded),
                  ),
                  Expanded(
                    child: Text(
                      '${controller.guestCount} guests',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: controller.incrementGuests,
                    icon: const Icon(Icons.add_circle_outline_rounded),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(
              title: 'Guest note',
              subtitle: 'Optional details like seating preference or celebration.',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _suggestedNotes
                  .map(
                    (suggestion) => ActionChip(
                      label: Text(suggestion),
                      onPressed: () {
                        controller.applySuggestedNote(suggestion);
                        noteController
                          ..text = controller.note
                          ..selection = TextSelection.collapsed(
                            offset: controller.note.length,
                          );
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              minLines: 3,
              maxLines: 4,
              onChanged: controller.updateNote,
              decoration: const InputDecoration(
                hintText: 'Window seat, birthday cake, stroller access...',
              ),
            ),
            if (controller.errorText != null) ...[
              const SizedBox(height: 14),
              Text(
                controller.errorText!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.red.shade700,
                ),
              ),
            ],
            ],
          );
        },
      ),
      bottomSheet: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final selectedSlot = controller.selectedSlot;

          return SafeArea(
            minimum: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: PrimaryCtaButton(
              label: selectedSlot == null
                  ? 'Send reservation request'
                  : 'Send request for ${DateTimeFormatters.shortTime(selectedSlot.startTime)}',
              isBusy: controller.isSubmitting,
              onPressed: () async {
                final success = await controller.submit();
                if (success && context.mounted) {
                  await showModalBottomSheet<void>(
                    context: context,
                    isDismissible: false,
                    enableDrag: false,
                    showDragHandle: true,
                    builder: (context) => _ReservationSuccessSheet(
                      restaurantName: widget.restaurant.name,
                      guestCount: controller.guestCount,
                      bookingDateTime: controller.selectedSlot!.startTime,
                    ),
                  );
                  if (context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class _DateChoicePill extends StatelessWidget {
  const _DateChoicePill({
    required this.dateLabel,
    required this.selected,
    required this.onTap,
  });

  final String dateLabel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        constraints: const BoxConstraints(minWidth: 122, minHeight: 58),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.charcoal : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.charcoal : AppColors.line,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          dateLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: selected ? Colors.white : AppColors.charcoal,
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
        ),
      ),
    );
  }
}

class _ReservationSnapshot extends StatelessWidget {
  const _ReservationSnapshot({
    required this.restaurant,
    required this.guestCount,
    required this.selectedDate,
    required this.selectedSlotLabel,
  });

  final Restaurant restaurant;
  final int guestCount;
  final DateTime selectedDate;
  final String selectedSlotLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reservation snapshot', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            '${restaurant.location} · ${restaurant.cuisine}',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SnapshotTag(label: DateTimeFormatters.shortDate(selectedDate)),
              _SnapshotTag(label: selectedSlotLabel),
              _SnapshotTag(label: '$guestCount guests'),
            ],
          ),
        ],
      ),
    );
  }
}

class _SnapshotTag extends StatelessWidget {
  const _SnapshotTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.soft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.charcoal,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _ReservationSuccessSheet extends StatelessWidget {
  const _ReservationSuccessSheet({
    required this.restaurantName,
    required this.guestCount,
    required this.bookingDateTime,
  });

  final String restaurantName;
  final int guestCount;
  final DateTime bookingDateTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: AppColors.cream,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.brandDeep,
                  size: 30,
                ),
              ),
              const SizedBox(height: 18),
              Text('Request sent', style: theme.textTheme.displaySmall),
              const SizedBox(height: 8),
              Text(
                '$restaurantName now has your booking request for ${DateTimeFormatters.bookingDateTime(bookingDateTime)}.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              Text(
                '$guestCount guests · Pending confirmation',
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 20),
              PrimaryCtaButton(
                label: 'View bookings',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
