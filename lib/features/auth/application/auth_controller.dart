import 'package:flutter/foundation.dart';

import '../../../app/domain/app_role.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_user.dart';

class AuthController extends ChangeNotifier {
  AuthController({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository {
    _authRepository.addListener(_syncFromRepository);
    _currentUser = _authRepository.currentUser;
  }

  final AuthRepository _authRepository;

  AuthUser? _currentUser;
  bool _isBusy = false;
  String? errorText;

  AuthUser? get currentUser => _currentUser;
  bool get isBusy => _isBusy;
  bool get isAuthenticated => _currentUser != null;
  AppRole get activeRole => _currentUser?.activeRole ?? AppRole.customer;

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isBusy = true;
    errorText = null;
    notifyListeners();

    if (email.trim().isEmpty || password.trim().isEmpty) {
      _isBusy = false;
      errorText = 'Enter both email and password to continue.';
      notifyListeners();
      return false;
    }

    await _authRepository.signIn(email: email.trim(), password: password.trim());
    _isBusy = false;
    notifyListeners();
    return true;
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _isBusy = true;
    errorText = null;
    notifyListeners();

    if (name.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
      _isBusy = false;
      errorText = 'Complete every field before creating an account.';
      notifyListeners();
      return false;
    }

    await _authRepository.signUp(
      name: name.trim(),
      email: email.trim(),
      password: password.trim(),
    );
    _isBusy = false;
    notifyListeners();
    return true;
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  void setActiveRole(AppRole role) {
    if (_currentUser == null) {
      return;
    }
    _currentUser = _currentUser!.copyWith(activeRole: role);
    notifyListeners();
  }

  void _syncFromRepository() {
    _currentUser = _authRepository.currentUser;
    notifyListeners();
  }

  @override
  void dispose() {
    _authRepository.removeListener(_syncFromRepository);
    super.dispose();
  }
}
