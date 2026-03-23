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
        builder: (context, _) => ListView(
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
            const SectionHeader(
              title: 'Pick a date',
              subtitle: 'Start with a day that works for your group.',
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 52,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  final date = DateTime.now().add(Duration(days: index));
                  final selected = DateTimeFormatters.isSameDate(
                    date,
                    controller.selectedDate,
                  );
                  return InkWell(
                    onTap: () => controller.selectDate(date),
                    borderRadius: BorderRadius.circular(18),
                    child: Ink(
                      width: 118,
                      decoration: BoxDecoration(
                        color: selected ? AppColors.charcoal : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: selected ? AppColors.charcoal : AppColors.line,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          DateTimeFormatters.shortDate(date),
                          style: TextStyle(
                            color: selected ? Colors.white : AppColors.charcoal,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, _) => const SizedBox(width: 10),
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
        ),
      ),
      bottomSheet: AnimatedBuilder(
        animation: controller,
        builder: (context, _) => SafeArea(
          minimum: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: PrimaryCtaButton(
            label: 'Send reservation request',
            isBusy: controller.isSubmitting,
            onPressed: () async {
              final success = await controller.submit();
              if (success && context.mounted) {
                Navigator.of(context).pop(true);
              }
            },
          ),
        ),
      ),
    );
  }
}
