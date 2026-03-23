import 'package:flutter/material.dart';

import '../../../app/app_scope.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/presentation/widgets/empty_state.dart';
import '../../../core/presentation/widgets/section_header.dart';

class AdminModeScreen extends StatefulWidget {
  const AdminModeScreen({super.key});

  @override
  State<AdminModeScreen> createState() => _AdminModeScreenState();
}

class _AdminModeScreenState extends State<AdminModeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppScope.of(context).adminController.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context).adminController;
    final discoverController = AppScope.of(context).discoverController;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Admin tools')),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          children: [
            const SectionHeader(
              title: 'Platform overview',
              subtitle: 'A lightweight approval queue and visibility into launch-readiness.',
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.line),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _MetricBlock(
                      label: 'Approved restaurants',
                      value: '${controller.approvedCount}',
                    ),
                  ),
                  Expanded(
                    child: _MetricBlock(
                      label: 'Pending approvals',
                      value: '${controller.pendingRestaurants.length}',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(
              title: 'Restaurant approvals',
              subtitle: 'Approve or reject newly onboarded restaurant profiles.',
            ),
            const SizedBox(height: 14),
            if (controller.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (controller.pendingRestaurants.isEmpty)
              const EmptyState(
                title: 'No restaurants awaiting review.',
                message: 'New restaurant draft profiles will appear here as owners onboard themselves.',
                icon: Icons.approval_outlined,
              )
            else
              for (final restaurant in controller.pendingRestaurants) ...[
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
                      Text(restaurant.name, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text('${restaurant.location} · ${restaurant.cuisine}'),
                      const SizedBox(height: 8),
                      Text(restaurant.openHours),
                      const SizedBox(height: 8),
                      Text('Capacity: ${restaurant.seatingCapacity} seats'),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          FilledButton.tonal(
                            onPressed: () async {
                              await controller.approveRestaurant(restaurant.id);
                              await discoverController.initialize();
                            },
                            child: const Text('Approve'),
                          ),
                          const SizedBox(width: 12),
                          TextButton(
                            onPressed: () async {
                              await controller.rejectRestaurant(restaurant.id);
                              await discoverController.initialize();
                            },
                            child: const Text('Reject'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],
          ],
        ),
      ),
    );
  }
}

class _MetricBlock extends StatelessWidget {
  const _MetricBlock({
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
        const SizedBox(height: 4),
        Text(label, style: theme.textTheme.bodyLarge),
      ],
    );
  }
}
