import 'package:flutter/cupertino.dart';

class Destination {
  final String id;
  final String city;
  final String province;
  final String country;
  final String description;
  final String imageUrl;
  final String category;
  final String season;
  final List<String> activities;
  final List<String> galleryImages;
  final double rating;
  final double latitude;
  final double longitude;
  final String address;
  final String bestTimeToVisit;
  final String contactNumber;
  final String entranceFee;
  final String openingHours;
  bool isFavorite;
  final bool isVacationSpot;

  Destination({
    required this.id,
    required this.city,
    required this.province,
    this.country = 'Sri Lanka',
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.season,
    required this.activities,
    required this.galleryImages,
    this.rating = 4.0,
    required this.latitude,
    required this.longitude,
    this.address = '',
    this.bestTimeToVisit = '',
    this.contactNumber = '',
    this.entranceFee = 'Free',
    this.openingHours = '8:00 AM - 6:00 PM',
    this.isFavorite = false,
    this.isVacationSpot = true,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'] as String? ?? UniqueKey().toString(),
      city: json['city'] as String? ?? 'Unknown City',
      province: json['province'] as String? ?? 'Unknown Province',
      country: json['country'] as String? ?? 'Sri Lanka',
      description: json['description'] as String? ?? 'No description available',
      imageUrl: json['imageUrl'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      season: json['season'] as String? ?? 'All Year',
      activities: List<String>.from(json['activities'] as List? ?? []),
      galleryImages: List<String>.from(json['galleryImages'] as List? ?? []),
      rating: (json['rating'] as num?)?.toDouble() ?? 4.0,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 7.8731,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 80.7718,
      address: json['address'] as String? ?? '',
      bestTimeToVisit: json['bestTimeToVisit'] as String? ?? '',
      contactNumber: json['contactNumber'] as String? ?? '',
      entranceFee: json['entranceFee'] as String? ?? 'Free',
      openingHours: json['openingHours'] as String? ?? '8:00 AM - 6:00 PM',
      isFavorite: json['isFavorite'] as bool? ?? false,
      isVacationSpot: json['isVacationSpot'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city': city,
      'province': province,
      'country': country,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'season': season,
      'activities': activities,
      'galleryImages': galleryImages,
      'rating': rating,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'bestTimeToVisit': bestTimeToVisit,
      'contactNumber': contactNumber,
      'entranceFee': entranceFee,
      'openingHours': openingHours,
      'isFavorite': isFavorite,
      'isVacationSpot': isVacationSpot,
    };
  }

  Destination copyWith({
    String? id,
    String? city,
    String? province,
    String? country,
    String? description,
    String? imageUrl,
    String? category,
    String? season,
    List<String>? activities,
    List<String>? galleryImages,
    double? rating,
    double? latitude,
    double? longitude,
    String? address,
    String? bestTimeToVisit,
    String? contactNumber,
    String? entranceFee,
    String? openingHours,
    bool? isFavorite,
    bool? isVacationSpot,
  }) {
    return Destination(
      id: id ?? this.id,
      city: city ?? this.city,
      province: province ?? this.province,
      country: country ?? this.country,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      season: season ?? this.season,
      activities: activities ?? this.activities,
      galleryImages: galleryImages ?? this.galleryImages,
      rating: rating ?? this.rating,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      bestTimeToVisit: bestTimeToVisit ?? this.bestTimeToVisit,
      contactNumber: contactNumber ?? this.contactNumber,
      entranceFee: entranceFee ?? this.entranceFee,
      openingHours: openingHours ?? this.openingHours,
      isFavorite: isFavorite ?? this.isFavorite,
      isVacationSpot: isVacationSpot ?? this.isVacationSpot,
    );
  }
}