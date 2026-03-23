import 'user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile?> fetchProfile(String userId);

  Future<UserProfile> saveProfile(UserProfile profile);
}
