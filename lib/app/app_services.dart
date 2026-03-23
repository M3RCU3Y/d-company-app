import 'data/mock_app_store.dart';
import '../features/admin/application/admin_controller.dart';
import '../features/admin/data/mock_admin_repository.dart';
import '../features/admin/domain/admin_repository.dart';
import '../features/auth/application/auth_controller.dart';
import '../features/auth/data/mock_auth_repository.dart';
import '../features/auth/domain/auth_repository.dart';
import '../features/bookings/application/bookings_controller.dart';
import '../features/bookings/data/mock_reservation_repository.dart';
import '../features/bookings/domain/reservation_repository.dart';
import '../features/discover/application/discover_controller.dart';
import '../features/discover/data/mock_restaurant_repository.dart';
import '../features/discover/domain/restaurant_repository.dart';
import '../features/profile/application/favorites_controller.dart';
import '../features/profile/application/profile_controller.dart';
import '../features/profile/data/mock_favorites_repository.dart';
import '../features/profile/data/mock_profile_repository.dart';
import '../features/profile/domain/favorites_repository.dart';
import '../features/profile/domain/profile_repository.dart';
import '../features/restaurant/application/restaurant_dashboard_controller.dart';

class AppServices {
  AppServices({
    required this.authRepository,
    required this.restaurantRepository,
    required this.reservationRepository,
    required this.profileRepository,
    required this.favoritesRepository,
    required this.adminRepository,
    required this.authController,
    required this.discoverController,
    required this.bookingsController,
    required this.profileController,
    required this.favoritesController,
    required this.restaurantDashboardController,
    required this.adminController,
  });

  factory AppServices.bootstrap() {
    final store = MockAppStore();
    final authRepository = MockAuthRepository(store);
    final restaurantRepository = MockRestaurantRepository(store);
    final reservationRepository = MockReservationRepository(store);
    final profileRepository = MockProfileRepository(store);
    final favoritesRepository = MockFavoritesRepository(store);
    final adminRepository = MockAdminRepository(store);
    final authController = AuthController(authRepository: authRepository);
    final discoverController = DiscoverController(
      restaurantRepository: restaurantRepository,
    );
    final bookingsController = BookingsController(
      reservationRepository: reservationRepository,
      restaurantRepository: restaurantRepository,
      authController: authController,
    );
    final profileController = ProfileController(
      authController: authController,
      profileRepository: profileRepository,
    );
    final favoritesController = FavoritesController(
      authController: authController,
      favoritesRepository: favoritesRepository,
    );
    final restaurantDashboardController = RestaurantDashboardController(
      authController: authController,
      restaurantRepository: restaurantRepository,
      reservationRepository: reservationRepository,
    );
    final adminController = AdminController(
      adminRepository: adminRepository,
    );

    discoverController.initialize();
    bookingsController.initialize();
    profileController.initialize();
    favoritesController.initialize();
    restaurantDashboardController.initialize();
    adminController.initialize();

    return AppServices(
      authRepository: authRepository,
      restaurantRepository: restaurantRepository,
      reservationRepository: reservationRepository,
      profileRepository: profileRepository,
      favoritesRepository: favoritesRepository,
      adminRepository: adminRepository,
      authController: authController,
      discoverController: discoverController,
      bookingsController: bookingsController,
      profileController: profileController,
      favoritesController: favoritesController,
      restaurantDashboardController: restaurantDashboardController,
      adminController: adminController,
    );
  }

  final AuthRepository authRepository;
  final RestaurantRepository restaurantRepository;
  final ReservationRepository reservationRepository;
  final ProfileRepository profileRepository;
  final FavoritesRepository favoritesRepository;
  final AdminRepository adminRepository;
  final AuthController authController;
  final DiscoverController discoverController;
  final BookingsController bookingsController;
  final ProfileController profileController;
  final FavoritesController favoritesController;
  final RestaurantDashboardController restaurantDashboardController;
  final AdminController adminController;

  void dispose() {
    authController.dispose();
    discoverController.dispose();
    bookingsController.dispose();
    profileController.dispose();
    favoritesController.dispose();
    restaurantDashboardController.dispose();
    adminController.dispose();
    reservationRepository.dispose();
    favoritesRepository.dispose();
    authRepository.dispose();
  }
}
