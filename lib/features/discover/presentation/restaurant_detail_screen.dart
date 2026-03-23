import 'package:flutter/material.dart';

import '../../../app/app_scope.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/presentation/widgets/primary_cta_button.dart';
import '../../../core/presentation/widgets/section_header.dart';
import '../domain/restaurant.dart';
import '../../bookings/presentation/reservation_form_screen.dart';

class RestaurantDetailScreen extends StatelessWidget {
  const RestaurantDetailScreen({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appScope = AppScope.of(context);
    final favoritesController = appScope.favoritesController;

    return AnimatedBuilder(
      animation: favoritesController,
      builder: (context, _) => Scaffold(
        body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.charcoal,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'restaurant-${restaurant.id}',
                    child: Image.network(
                      restaurant.heroImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.cream,
                        child: const Icon(
                          Icons.restaurant_rounded,
                          size: 52,
                          color: AppColors.brand,
                        ),
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.18),
                          Colors.black.withOpacity(0.64),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: theme.textTheme.displaySmall?.copyWith(fontSize: 34),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      IconButton.filledTonal(
                        onPressed: () {
                          favoritesController.toggleFavorite(restaurant.id);
                        },
                        icon: Icon(
                          favoritesController.isFavorite(restaurant.id)
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        favoritesController.isFavorite(restaurant.id)
                            ? 'Saved for later'
                            : 'Save restaurant',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${restaurant.cuisine} · ${restaurant.location} · ${restaurant.priceLevel}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.charcoal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: restaurant.tags
                        .map(
                          (tag) => Chip(
                            label: Text(tag),
                            backgroundColor: AppColors.soft,
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  _InfoRow(
                    label: 'Atmosphere',
                    value: restaurant.vibe,
                  ),
                  const SizedBox(height: 18),
                  _InfoRow(
                    label: 'Location',
                    value: restaurant.address,
                  ),
                  const SizedBox(height: 18),
                  _InfoRow(
                    label: 'Hours',
                    value: restaurant.openHours,
                  ),
                  const SizedBox(height: 18),
                  _InfoRow(
                    label: 'About',
                    value: restaurant.description,
                  ),
                  const SizedBox(height: 18),
                  _InfoRow(
                    label: 'Next reservation',
                    value: restaurant.nextSlotLabel,
                  ),
                  const SizedBox(height: 30),
                  const SectionHeader(
                    title: 'Why book here',
                    subtitle: 'The next slice of the app should make it easier to move from interest to confirmation without DM back-and-forth.',
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Text(
                      'Choose a time, add guest notes, and send a clear request that the restaurant can confirm from one place.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.charcoal.withOpacity(0.78),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
        bottomSheet: SafeArea(
          minimum: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: PrimaryCtaButton(
            label: 'Reserve for ${restaurant.nextSlotLabel}',
            onPressed: () async {
              final created = await Navigator.of(context).push<bool>(
                MaterialPageRoute<bool>(
                  builder: (_) => ReservationFormScreen(
                    restaurant: restaurant,
                    restaurantRepository: appScope.restaurantRepository,
                    reservationRepository: appScope.reservationRepository,
                    authController: appScope.authController,
                  ),
                ),
              );

              if (created == true && context.mounted) {
                Navigator.of(context).pop(true);
              }
            },
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
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
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.slate,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 18,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
