import 'notification_preference.dart';

class UserProfile {
  const UserProfile({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.preferredDiningArea,
    required this.notifications,
  });

  final String userId;
  final String name;
  final String email;
  final String phone;
  final String preferredDiningArea;
  final NotificationPreference notifications;

  UserProfile copyWith({
    String? userId,
    String? name,
    String? email,
    String? phone,
    String? preferredDiningArea,
    NotificationPreference? notifications,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      preferredDiningArea: preferredDiningArea ?? this.preferredDiningArea,
      notifications: notifications ?? this.notifications,
    );
  }
}
