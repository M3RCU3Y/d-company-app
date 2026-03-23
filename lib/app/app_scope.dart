import 'package:flutter/widgets.dart';

import '../features/admin/application/admin_controller.dart';
import '../features/auth/application/auth_controller.dart';
import '../features/bookings/application/bookings_controller.dart';
import '../features/bookings/domain/reservation_repository.dart';
import '../features/discover/application/discover_controller.dart';
import '../features/discover/domain/restaurant_repository.dart';
import '../features/profile/application/favorites_controller.dart';
import '../features/profile/application/profile_controller.dart';
import '../features/profile/domain/favorites_repository.dart';
import '../features/profile/domain/profile_repository.dart';
import '../features/restaurant/application/restaurant_dashboard_controller.dart';
import 'app_services.dart';

class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required this.services,
    required super.child,
  });

  final AppServices services;

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope is missing above this context.');
    return scope!;
  }

  DiscoverController get discoverController => services.discoverController;
  BookingsController get bookingsController => services.bookingsController;
  AuthController get authController => services.authController;
  ProfileController get profileController => services.profileController;
  FavoritesController get favoritesController => services.favoritesController;
  RestaurantDashboardController get restaurantDashboardController =>
      services.restaurantDashboardController;
  AdminController get adminController => services.adminController;
  RestaurantRepository get restaurantRepository => services.restaurantRepository;
  ReservationRepository get reservationRepository => services.reservationRepository;
  ProfileRepository get profileRepository => services.profileRepository;
  FavoritesRepository get favoritesRepository => services.favoritesRepository;

  @override
  bool updateShouldNotify(AppScope oldWidget) => services != oldWidget.services;
}
