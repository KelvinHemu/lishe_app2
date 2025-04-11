import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/food_item.dart';
import '../../meal_planner/models/nutrition_data.dart';

final foodNutritionProvider =
    FutureProvider.family<List<NutritionCategory>, FoodItem>(
        (ref, foodItem) async {
  try {
    return [
      // Basic Nutrition
      NutritionCategory(
        title: 'Basic Nutrition',
        unit: '',
        items: [
          NutritionItem(
            name: 'Calories',
            value: foodItem.calories ?? 0.0,
            unit: 'kcal',
          ),
          NutritionItem(
            name: 'Protein',
            value: foodItem.protein ?? 0.0,
            unit: 'g',
          ),
          NutritionItem(
            name: 'Carbohydrates',
            value: foodItem.carbs ?? 0.0,
            unit: 'g',
          ),
          NutritionItem(
            name: 'Fat',
            value: foodItem.fat ?? 0.0,
            unit: 'g',
          ),
          NutritionItem(
            name: 'Fiber',
            value: foodItem.fiber ?? 0.0,
            unit: 'g',
          ),
          NutritionItem(
            name: 'Sugar',
            value: foodItem.sugar ?? 0.0,
            unit: 'g',
          ),
        ],
      ),

      // Minerals
      NutritionCategory(
        title: 'Minerals',
        unit: '',
        items: [
          NutritionItem(
            name: 'Sodium',
            value: foodItem.sodium ?? 0.0,
            unit: 'mg',
          ),
          NutritionItem(
            name: 'Potassium',
            value: foodItem.potassium ?? 0.0,
            unit: 'mg',
          ),
          NutritionItem(
            name: 'Calcium',
            value: foodItem.calcium ?? 0.0,
            unit: 'mg',
          ),
          NutritionItem(
            name: 'Iron',
            value: foodItem.iron ?? 0.0,
            unit: 'mg',
          ),
        ],
      ),

      // Fats
      NutritionCategory(
        title: 'Fats',
        unit: '',
        items: [
          NutritionItem(
            name: 'Saturated Fat',
            value: foodItem.saturatedFat ?? 0.0,
            unit: 'g',
          ),
          NutritionItem(
            name: 'Unsaturated Fat',
            value: foodItem.unsaturatedFat ?? 0.0,
            unit: 'g',
          ),
          NutritionItem(
            name: 'Trans Fat',
            value: foodItem.transFat ?? 0.0,
            unit: 'g',
          ),
          NutritionItem(
            name: 'Cholesterol',
            value: foodItem.cholesterol ?? 0.0,
            unit: 'mg',
          ),
        ],
      ),

      // Vitamins
      NutritionCategory(
        title: 'Vitamins',
        unit: '',
        items: [
          NutritionItem(
            name: 'Vitamin A',
            value: foodItem.vitaminA ?? 0.0,
            unit: 'IU',
          ),
          NutritionItem(
            name: 'Vitamin C',
            value: foodItem.vitaminC ?? 0.0,
            unit: 'mg',
          ),
        ],
      ),
    ];
  } catch (e) {
    // Return default nutrition data if there's an error
    return [
      NutritionCategory(
        title: 'Basic Nutrition',
        unit: '',
        items: [
          const NutritionItem(name: 'Calories', value: 0, unit: 'kcal'),
          const NutritionItem(name: 'Protein', value: 0, unit: 'g'),
          const NutritionItem(name: 'Carbohydrates', value: 0, unit: 'g'),
          const NutritionItem(name: 'Fat', value: 0, unit: 'g'),
        ],
      ),
    ];
  }
});
