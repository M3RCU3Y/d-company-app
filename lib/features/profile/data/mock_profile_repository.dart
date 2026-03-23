import '../../../app/data/mock_app_store.dart';
import '../domain/profile_repository.dart';
import '../domain/user_profile.dart';

class MockProfileRepository implements ProfileRepository {
  MockProfileRepository(this._store);

  final MockAppStore _store;

  @override
  Future<UserProfile?> fetchProfile(String userId) async {
    return _store.profiles[userId];
  }

  @override
  Future<UserProfile> saveProfile(UserProfile profile) async {
    _store.profiles[profile.userId] = profile;
    return profile;
  }
}
