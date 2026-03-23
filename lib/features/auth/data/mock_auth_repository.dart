import '../../../app/data/mock_app_store.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_user.dart';

class MockAuthRepository extends AuthRepository {
  MockAuthRepository(this._store);

  final MockAppStore _store;

  @override
  AuthUser? get currentUser => _store.currentUser;

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    final matchingProfiles =
        _store.profiles.values.where((profile) => profile.email == email);
    final existingProfile =
        matchingProfiles.isEmpty ? null : matchingProfiles.first;
    final user = AuthUser(
      id: existingProfile?.userId ??
          'user-${(_store.profiles.length + 1).toString().padLeft(3, '0')}',
      email: email,
      displayName: existingProfile?.name ?? email.split('@').first,
    );
    _store.currentUser = user;
    notifyListeners();
    return user;
  }

  @override
  Future<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final user = AuthUser(
      id: 'user-${(_store.profiles.length + 1).toString().padLeft(3, '0')}',
      email: email,
      displayName: name,
    );
    _store.currentUser = user;
    notifyListeners();
    return user;
  }

  @override
  Future<void> signOut() async {
    _store.currentUser = null;
    notifyListeners();
  }
}
