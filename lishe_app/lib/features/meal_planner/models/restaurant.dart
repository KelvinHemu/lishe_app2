class Restaurant {
  final String id;
  final String name;
  final String distance;
  final double rating;
  final String imageUrl;
  final String? address;
  final List<String>? cuisineTypes;

  Restaurant({
    required this.id,
    required this.name,
    required this.distance,
    required this.rating,
    required this.imageUrl,
    this.address,
    this.cuisineTypes,
  });
}
