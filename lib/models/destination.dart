class Destination {
  final String city;
  final String country;
  final String imageUrl;
  final String description;
  final List<String> activities;
  final List<String> galleryImages;
  final String season;
  final String province;
  final String isVacationSpot;
  final String category;
  bool isFavorite;

  Destination({
    required this.city,
    required this.country,
    required this.imageUrl,
    required this.description,
    required this.activities,
    required this.galleryImages,
    required this.season,
    required this.province,
    required this.isVacationSpot,
    required this.category,
    this.isFavorite = false,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      city: json['city'],
      country: json['country'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      activities: List<String>.from(json['activities']),
      galleryImages: List<String>.from(json['galleryImages']),
      season: json['season'],
      province: json['province'],
      isVacationSpot: json['isVacationSpot'],
      category: json['category'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'country': country,
      'imageUrl': imageUrl,
      'description': description,
      'activities': activities,
      'galleryImages': galleryImages,
      'season': season,
      'province': province,
      'isVacationSpot': isVacationSpot,
      'category': category,
      'isFavorite': isFavorite,
    };
  }
}