import 'package:flutter/material.dart';

import '../../../app/app_scope.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/presentation/widgets/primary_cta_button.dart';
import '../../../core/presentation/widgets/section_header.dart';
import '../../../features/admin/presentation/admin_mode_screen.dart';
import '../../../features/restaurant/presentation/restaurant_mode_screen.dart';
import 'notifications_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final areaController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authController = AppScope.of(context).authController;
    final profileController = AppScope.of(context).profileController;
    final favoritesController = AppScope.of(context).favoritesController;

    return AnimatedBuilder(
      animation: Listenable.merge([authController, profileController, favoritesController]),
      builder: (context, _) {
        final user = authController.currentUser;
        final profile = profileController.profile;
        if (profile != null) {
          nameController.text = profile.name;
          phoneController.text = profile.phone;
          areaController.text = profile.preferredDiningArea;
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
          children: [
            Text(
              'Profile',
              style: theme.textTheme.displaySmall,
            ),
            const SizedBox(height: 10),
            Text(
              'Manage your account, saved restaurants, and internal launch tools.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.cream,
                    child: Text(
                      ((user?.displayName.isNotEmpty ?? false)
                              ? user!.displayName[0]
                              : 'D')
                          .toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.brandDeep,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    user?.email ?? 'Guest',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${favoritesController.favoriteIds.length} saved restaurants',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(
              title: 'Account details',
              subtitle: 'Lightweight customer profile management before full backend sync.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: areaController,
              decoration: const InputDecoration(labelText: 'Preferred dining area'),
            ),
            const SizedBox(height: 16),
            PrimaryCtaButton(
              label: 'Save profile',
              isBusy: profileController.isSaving,
              onPressed: () async {
                await profileController.saveProfile(
                  name: nameController.text,
                  phone: phoneController.text,
                  preferredDiningArea: areaController.text,
                  reservationUpdatesEnabled:
                      profile?.notifications.reservationUpdatesEnabled ?? true,
                  savedRestaurantAlertsEnabled:
                      profile?.notifications.savedRestaurantAlertsEnabled ?? false,
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated.')),
                  );
                }
              },
            ),
            const SizedBox(height: 24),
            const SectionHeader(
              title: 'Notifications and launch tools',
              subtitle: 'Customer preferences plus separated internal routes for restaurant and admin work.',
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Notifications'),
              subtitle: const Text('Open placeholder preferences and future inbox setup'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const NotificationsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Restaurant mode'),
              subtitle: const Text('Onboarding, hours, capacity, and reservation approvals'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const RestaurantModeScreen(),
                  ),
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Admin mode'),
              subtitle: const Text('Restaurant approval queue and launch oversight'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AdminModeScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => authController.signOut(),
              child: const Text('Sign out'),
            ),
          ],
        );
      },
    );
  }
}
