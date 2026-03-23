import 'package:flutter/material.dart';

import '../../../app/app_scope.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/presentation/widgets/empty_state.dart';
import '../../../core/presentation/widgets/filter_chip_row.dart';
import '../../../core/presentation/widgets/restaurant_media_card.dart';
import '../../../core/presentation/widgets/search_input.dart';
import '../../../core/presentation/widgets/section_header.dart';
import '../application/discover_controller.dart';
import 'restaurant_detail_screen.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({
    super.key,
    required this.onReservationCreated,
  });

  final ValueChanged<String> onReservationCreated;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = AppScope.of(context).discoverController;
    final favoritesController = AppScope.of(context).favoritesController;

    return AnimatedBuilder(
      animation: Listenable.merge([controller, favoritesController]),
      builder: (context, _) => CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'D Table',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.brand,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 650),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 24 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.charcoal,
                            AppColors.brandDeep,
                            AppColors.accent,
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -40,
                            top: -10,
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.08),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Book the room before the group chat gets chaotic.',
                                  style: theme.textTheme.displaySmall?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Search by cuisine, city, or restaurant name and move from browsing to booking in one place.',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: Colors.white.withOpacity(0.78),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    _HeroMetric(
                                      label: 'Visible spots',
                                      value: '${controller.restaurants.length}',
                                    ),
                                    const SizedBox(width: 20),
                                    const _HeroMetric(
                                      label: 'Fastest confirmation',
                                      value: '12 min',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SearchInput(
                    initialValue: controller.filters.query,
                    hintText: 'Search restaurant, cuisine, or location',
                    onChanged: controller.setQuery,
                  ),
                  const SizedBox(height: 18),
                  SectionHeader(
                    title: 'Browse by mood',
                    subtitle: 'Layer quick filters on top of search to narrow the shortlist fast.',
                  ),
                  const SizedBox(height: 12),
                  FilterChipRow(
                    options: DiscoverController.filterOptions,
                    selected: controller.filters.selectedCategory,
                    onSelected: controller.setCategory,
                  ),
                ],
              ),
            ),
          ),
          if (controller.isLoading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (controller.restaurants.isEmpty)
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 28),
              sliver: SliverToBoxAdapter(
                child: EmptyState(
                  title: 'No restaurants match this search.',
                  message: 'Try another cuisine, location, or mood filter.',
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final restaurant = controller.restaurants[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: RestaurantMediaCard(
                        restaurant: restaurant,
                        trailing: IconButton.filledTonal(
                          onPressed: () {
                            favoritesController.toggleFavorite(restaurant.id);
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.18),
                          ),
                          icon: Icon(
                            favoritesController.isFavorite(restaurant.id)
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: favoritesController.isFavorite(restaurant.id)
                                ? AppColors.gold
                                : Colors.white,
                          ),
                        ),
                        onTap: () async {
                          final created = await Navigator.of(context).push<bool>(
                            MaterialPageRoute<bool>(
                              builder: (_) => RestaurantDetailScreen(
                                restaurant: restaurant,
                              ),
                            ),
                          );

                          if (created == true) {
                            onReservationCreated('Reservation request sent.');
                          }
                        },
                      ),
                    );
                  },
                  childCount: controller.restaurants.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontSize: 24,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.72),
              ),
        ),
      ],
    );
  }
}
