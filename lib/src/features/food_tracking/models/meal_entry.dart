import 'food_item.dart';

class MealEntry {
  final String id;
  final DateTime timestamp;
  final String mealType; // breakfast, lunch, dinner, snack
  final List<MealItem> items;

  MealEntry({
    required this.id,
    required this.timestamp,
    required this.mealType,
    required this.items,
  });

  double get totalCalories => items.fold(
      0, (sum, item) => sum + (item.foodItem.calories * item.servings));

  double get totalProteins => items.fold(
      0, (sum, item) => sum + (item.foodItem.proteins * item.servings));

  double get totalCarbs =>
      items.fold(0, (sum, item) => sum + (item.foodItem.carbs * item.servings));

  double get totalFats =>
      items.fold(0, (sum, item) => sum + (item.foodItem.fats * item.servings));

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'mealType': mealType,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory MealEntry.fromJson(Map<String, dynamic> json) {
    return MealEntry(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      mealType: json['mealType'],
      items: (json['items'] as List)
          .map((item) => MealItem.fromJson(item))
          .toList(),
    );
  }
}

class MealItem {
  final FoodItem foodItem;
  final double servings;
  final String? notes;

  MealItem({
    required this.foodItem,
    required this.servings,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'foodItem': foodItem.toJson(),
      'servings': servings,
      'notes': notes,
    };
  }

  factory MealItem.fromJson(Map<String, dynamic> json) {
    return MealItem(
      foodItem: FoodItem.fromJson(json['foodItem']),
      servings: json['servings'].toDouble(),
      notes: json['notes'],
    );
  }
} 