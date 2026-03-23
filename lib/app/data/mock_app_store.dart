import '../../features/auth/domain/auth_user.dart';
import '../../features/bookings/domain/reservation.dart';
import '../../features/bookings/domain/reservation_status.dart';
import '../../features/discover/domain/restaurant.dart';
import '../../features/profile/domain/notification_preference.dart';
import '../../features/profile/domain/user_profile.dart';
import '../../features/restaurant/domain/restaurant_approval_status.dart';

class MockAppStore {
  AuthUser? currentUser;

  final profiles = <String, UserProfile>{
    'user-001': const UserProfile(
      userId: 'user-001',
      name: 'Ari Charles',
      email: 'ari@dtable.app',
      phone: '868-555-0123',
      preferredDiningArea: 'Port of Spain',
      notifications: NotificationPreference(
        reservationUpdatesEnabled: true,
        savedRestaurantAlertsEnabled: false,
      ),
    ),
  };

  final favoriteRestaurantIds = <String, Set<String>>{
    'user-001': {'estate-101'},
  };

  final restaurants = <Restaurant>[
    const Restaurant(
      id: 'estate-101',
      name: 'Estate 101',
      ownerId: 'user-001',
      location: 'Port of Spain',
      address: '14 Queen’s Park West, Port of Spain',
      cuisine: 'Caribbean Fusion',
      priceLevel: '\$\$\$',
      rating: 4.8,
      reviewCount: 218,
      description:
          'An intimate dining room with wood-fire mains, polished service, and a late-evening energy that feels dressed up without becoming stiff.',
      heroImage:
          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1200&q=80',
      vibe: 'Chef-led tasting menus and date-night bookings.',
      openHours: 'Mon-Sun · 5:30 PM to 11:00 PM',
      nextSlotLabel: 'Tonight, 8:30 PM',
      seatingCapacity: 42,
      approvalStatus: RestaurantApprovalStatus.approved,
      tags: ['Trending', 'Date Night', 'Cocktails'],
    ),
    const Restaurant(
      id: 'maracas-tide',
      name: 'Maracas Tide',
      ownerId: 'user-001',
      location: 'Maraval',
      address: '7 Saddle Road, Maraval',
      cuisine: 'Seafood',
      priceLevel: '\$\$',
      rating: 4.6,
      reviewCount: 164,
      description:
          'Fresh seafood, citrus-forward plates, and a breezy room designed for long lunches that roll naturally into sunset drinks.',
      heroImage:
          'https://images.unsplash.com/photo-1559339352-11d035aa65de?auto=format&fit=crop&w=1200&q=80',
      vibe: 'Laid-back lunches with polished island details.',
      openHours: 'Tue-Sun · 12:00 PM to 10:00 PM',
      nextSlotLabel: 'Tomorrow, 1:00 PM',
      seatingCapacity: 56,
      approvalStatus: RestaurantApprovalStatus.approved,
      tags: ['Seafood', 'Family', 'Lunch'],
    ),
    const Restaurant(
      id: 'cocoa-yard',
      name: 'Cocoa Yard',
      ownerId: 'user-001',
      location: 'San Fernando',
      address: '38 Cipero Street, San Fernando',
      cuisine: 'Modern Creole',
      priceLevel: '\$\$',
      rating: 4.7,
      reviewCount: 126,
      description:
          'A warm, amber-lit room with bold local flavors, cocoa-rubbed proteins, and a menu built for shared tables and celebrations.',
      heroImage:
          'https://images.unsplash.com/photo-1552566626-52f8b828add9?auto=format&fit=crop&w=1200&q=80',
      vibe: 'Celebration dinners with generous portions.',
      openHours: 'Wed-Mon · 4:00 PM to 11:30 PM',
      nextSlotLabel: 'Friday, 7:15 PM',
      seatingCapacity: 68,
      approvalStatus: RestaurantApprovalStatus.approved,
      tags: ['Groups', 'Live Music', 'Trending'],
    ),
    const Restaurant(
      id: 'harbor-flame',
      name: 'Harbor Flame',
      ownerId: 'owner-demo',
      location: 'Chaguanas',
      address: '22 Main Road, Chaguanas',
      cuisine: 'Grill House',
      priceLevel: '\$\$',
      rating: 4.3,
      reviewCount: 24,
      description:
          'An incoming grill concept focused on group dinners, smoky mains, and later-evening bookings.',
      heroImage:
          'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?auto=format&fit=crop&w=1200&q=80',
      vibe: 'Big-table celebrations and late seating.',
      openHours: 'Thu-Sun · 4:30 PM to 11:30 PM',
      nextSlotLabel: 'Pending approval',
      seatingCapacity: 48,
      approvalStatus: RestaurantApprovalStatus.pending,
      tags: ['Groups', 'New'],
    ),
  ];

  final reservations = <Reservation>[
    Reservation(
      id: 'res-001',
      restaurantId: 'estate-101',
      userId: 'user-001',
      userName: 'Ari Charles',
      partySize: 4,
      dateTime: DateTime.now().add(const Duration(days: 2, hours: 3)),
      status: ReservationStatus.pending,
      note: 'Celebrating a birthday.',
    ),
    Reservation(
      id: 'res-002',
      restaurantId: 'maracas-tide',
      userId: 'user-001',
      userName: 'Ari Charles',
      partySize: 2,
      dateTime: DateTime.now().add(const Duration(days: 5, hours: 1)),
      status: ReservationStatus.confirmed,
    ),
    Reservation(
      id: 'res-003',
      restaurantId: 'cocoa-yard',
      userId: 'user-001',
      userName: 'Ari Charles',
      partySize: 6,
      dateTime: DateTime.now().subtract(const Duration(days: 4)),
      status: ReservationStatus.completed,
    ),
  ];
}
