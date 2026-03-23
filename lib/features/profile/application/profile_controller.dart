import 'package:flutter/foundation.dart';

import '../../auth/application/auth_controller.dart';
import '../domain/notification_preference.dart';
import '../domain/profile_repository.dart';
import '../domain/user_profile.dart';

class ProfileController extends ChangeNotifier {
  ProfileController({
    required AuthController authController,
    required ProfileRepository profileRepository,
  })  : _authController = authController,
        _profileRepository = profileRepository {
    _authController.addListener(_handleAuthChanged);
  }

  final AuthController _authController;
  final ProfileRepository _profileRepository;

  UserProfile? _profile;
  bool _isSaving = false;

  UserProfile? get profile => _profile;
  bool get isSaving => _isSaving;

  Future<void> initialize() async {
    await _load();
  }

  Future<void> saveProfile({
    required String name,
    required String phone,
    required String preferredDiningArea,
    required bool reservationUpdatesEnabled,
    required bool savedRestaurantAlertsEnabled,
  }) async {
    final user = _authController.currentUser;
    if (user == null) {
      return;
    }

    _isSaving = true;
    notifyListeners();

    final profile = UserProfile(
      userId: user.id,
      name: name,
      email: user.email,
      phone: phone,
      preferredDiningArea: preferredDiningArea,
      notifications: NotificationPreference(
        reservationUpdatesEnabled: reservationUpdatesEnabled,
        savedRestaurantAlertsEnabled: savedRestaurantAlertsEnabled,
      ),
    );

    _profile = await _profileRepository.saveProfile(profile);
    _isSaving = false;
    notifyListeners();
  }

  Future<void> _load() async {
    final user = _authController.currentUser;
    if (user == null) {
      _profile = null;
      notifyListeners();
      return;
    }

    _profile = await _profileRepository.fetchProfile(user.id) ??
        UserProfile(
          userId: user.id,
          name: user.displayName,
          email: user.email,
          phone: '',
          preferredDiningArea: 'Port of Spain',
          notifications: const NotificationPreference(
            reservationUpdatesEnabled: true,
            savedRestaurantAlertsEnabled: false,
          ),
        );
    notifyListeners();
  }

  void _handleAuthChanged() {
    _load();
  }

  @override
  void dispose() {
    _authController.removeListener(_handleAuthChanged);
    super.dispose();
  }
}
