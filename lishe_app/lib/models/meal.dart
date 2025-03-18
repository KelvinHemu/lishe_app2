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
  });

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
    );
  }
}
