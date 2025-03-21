class Meal {
  final String id;
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final String imageUrl;
  final List<String> ingredients;
  final String recipe;
  final List<String> mealTypes; // breakfast, lunch, dinner
  final String? storageInformation;
  final String? category;
  final String description;
  final int? weight;
  final int? servingSize;
  final String preparationTime;
  final String
  difficulty; // Only one difficulty field, non-nullable with default

  Meal({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.imageUrl = '',
    this.ingredients = const [],
    this.recipe = '',
    this.mealTypes = const [],
    this.storageInformation,
    this.category,
    this.difficulty = 'Medium',
    this.description = 'A delicious and nutritious meal', // Default description
    this.weight = 250, // Default weight in grams
    this.servingSize = 1, // Default serving size
    this.preparationTime = '30 mins',
  });

  // Update toMap and fromMap methods
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'recipe': recipe,
      'mealTypes': mealTypes,
      'storageInformation': storageInformation,
      'category': category,
      'difficulty': difficulty,
      'description': description,
      'weight': weight,
      'servingSize': servingSize,
      'preparationTime': preparationTime,
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      calories: map['calories'] ?? 0,
      protein: (map['protein'] ?? 0).toDouble(),
      carbs: (map['carbs'] ?? 0).toDouble(),
      fat: (map['fat'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      ingredients: List<String>.from(map['ingredients'] ?? []),
      recipe: map['recipe'] ?? '',
      mealTypes: List<String>.from(map['mealTypes'] ?? []),
      storageInformation: map['storageInformation'],
      category: map['category'],
      difficulty: map['difficulty'],
      description: map['description'] ?? 'A delicious and nutritious meal',
      weight: map['weight'] ?? 250,
      servingSize: map['servingSize'] ?? 1,
      preparationTime: map['preparationTime'] ?? '30 mins',
    );
  }
}
