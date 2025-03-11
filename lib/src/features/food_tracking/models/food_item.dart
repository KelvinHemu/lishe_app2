class FoodItem {
  final String id;
  final String name;
  final double calories;
  final double proteins;
  final double carbs;
  final double fats;
  final String? imageUrl;
  final double servingSize; // in grams
  final String servingUnit; // e.g., "g", "ml", "piece"

  FoodItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
    this.imageUrl,
    required this.servingSize,
    required this.servingUnit,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'proteins': proteins,
      'carbs': carbs,
      'fats': fats,
      'imageUrl': imageUrl,
      'servingSize': servingSize,
      'servingUnit': servingUnit,
    };
  }

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      name: json['name'],
      calories: json['calories'].toDouble(),
      proteins: json['proteins'].toDouble(),
      carbs: json['carbs'].toDouble(),
      fats: json['fats'].toDouble(),
      imageUrl: json['imageUrl'],
      servingSize: json['servingSize'].toDouble(),
      servingUnit: json['servingUnit'],
    );
  }
} 