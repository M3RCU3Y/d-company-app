import '../../restaurant/domain/restaurant_approval_status.dart';

class Restaurant {
  const Restaurant({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.location,
    required this.address,
    required this.cuisine,
    required this.priceLevel,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.heroImage,
    required this.vibe,
    required this.openHours,
    required this.nextSlotLabel,
    required this.seatingCapacity,
    required this.approvalStatus,
    required this.tags,
  });

  final String id;
  final String name;
  final String ownerId;
  final String location;
  final String address;
  final String cuisine;
  final String priceLevel;
  final double rating;
  final int reviewCount;
  final String description;
  final String heroImage;
  final String vibe;
  final String openHours;
  final String nextSlotLabel;
  final int seatingCapacity;
  final RestaurantApprovalStatus approvalStatus;
  final List<String> tags;

  Restaurant copyWith({
    String? id,
    String? name,
    String? ownerId,
    String? location,
    String? address,
    String? cuisine,
    String? priceLevel,
    double? rating,
    int? reviewCount,
    String? description,
    String? heroImage,
    String? vibe,
    String? openHours,
    String? nextSlotLabel,
    int? seatingCapacity,
    RestaurantApprovalStatus? approvalStatus,
    List<String>? tags,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      location: location ?? this.location,
      address: address ?? this.address,
      cuisine: cuisine ?? this.cuisine,
      priceLevel: priceLevel ?? this.priceLevel,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      description: description ?? this.description,
      heroImage: heroImage ?? this.heroImage,
      vibe: vibe ?? this.vibe,
      openHours: openHours ?? this.openHours,
      nextSlotLabel: nextSlotLabel ?? this.nextSlotLabel,
      seatingCapacity: seatingCapacity ?? this.seatingCapacity,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      tags: tags ?? this.tags,
    );
  }
}
