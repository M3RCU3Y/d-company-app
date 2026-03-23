import '../../../app/domain/app_role.dart';

class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.activeRole = AppRole.customer,
  });

  final String id;
  final String email;
  final String displayName;
  final AppRole activeRole;

  AuthUser copyWith({
    String? id,
    String? email,
    String? displayName,
    AppRole? activeRole,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      activeRole: activeRole ?? this.activeRole,
    );
  }
}
