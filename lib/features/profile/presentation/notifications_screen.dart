import 'package:flutter/material.dart';

import '../../../app/app_scope.dart';
import '../../../core/presentation/widgets/section_header.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = AppScope.of(context).profileController.profile;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: [
          const SectionHeader(
            title: 'Notification center',
            subtitle: 'Placeholder preferences while Firebase Cloud Messaging is still being wired.',
          ),
          const SizedBox(height: 20),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Reservation updates'),
            subtitle: const Text('Booking confirmations, changes, and cancellations'),
            trailing: Switch(
              value: profile?.notifications.reservationUpdatesEnabled ?? true,
              onChanged: null,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Saved restaurant alerts'),
            subtitle: const Text('Soft reminders when favorite spots open reservations'),
            trailing: Switch(
              value: profile?.notifications.savedRestaurantAlertsEnabled ?? false,
              onChanged: null,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Delivery plumbing will later use Firebase Cloud Messaging, but this screen already gives the product a dedicated place for preferences and future inbox items.',
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
