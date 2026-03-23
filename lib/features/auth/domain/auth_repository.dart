import 'package:flutter/foundation.dart';

import 'auth_user.dart';

abstract class AuthRepository extends ChangeNotifier {
  AuthUser? get currentUser;

  Future<AuthUser> signIn({
    required String email,
    required String password,
  });

  Future<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<void> signOut();
}
