import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/nutrition_data.dart';

final mealNutritionProvider =
    FutureProvider.family<List<NutritionCategory>, String>((ref, mealId) async {
  // Simulate API delay
  await Future.delayed(const Duration(milliseconds: 800));

  // Here you would typically call a service to fetch nutrition data
  // For now, we're returning mock data based on the meal ID

  return [
    // Basic nutrition (no specific unit as they vary)
    const NutritionCategory(
      title: 'Basic Nutrition',
      unit: '',
      items: [
        NutritionItem(name: 'Calories', value: 350, unit: 'kcal'),
        NutritionItem(name: 'Protein', value: 15.2, unit: 'g'),
        NutritionItem(name: 'Carbohydrates', value: 45.3, unit: 'g'),
        NutritionItem(name: 'Fat', value: 12.1, unit: 'g'),
        NutritionItem(name: 'Fiber', value: 5.5, unit: 'g'),
        NutritionItem(name: 'Sugar', value: 8.2, unit: 'g'),
      ],
    ),

    // Micronutrients (micrograms)
    const NutritionCategory(
      title: 'Micronutrients (micrograms)',
      unit: 'mcg',
      items: [
        NutritionItem(name: 'Vitamin A', value: 850, unit: 'mcg'),
        NutritionItem(name: 'Vitamin D', value: 5.2, unit: 'mcg'),
        NutritionItem(name: 'Vitamin K', value: 75, unit: 'mcg'),
        NutritionItem(name: 'Folate', value: 125, unit: 'mcg'),
        NutritionItem(name: 'Biotin', value: 12, unit: 'mcg'),
      ],
    ),

    // Micronutrients (milligrams)
    const NutritionCategory(
      title: 'Micronutrients (milligrams)',
      unit: 'mg',
      items: [
        NutritionItem(name: 'Vitamin C', value: 45, unit: 'mg'),
        NutritionItem(name: 'Vitamin E', value: 8.2, unit: 'mg'),
        NutritionItem(name: 'Vitamin B6', value: 0.7, unit: 'mg'),
        NutritionItem(name: 'Niacin (B3)', value: 6.5, unit: 'mg'),
        NutritionItem(name: 'Riboflavin (B2)', value: 0.4, unit: 'mg'),
        NutritionItem(name: 'Thiamine (B1)', value: 0.5, unit: 'mg'),
      ],
    ),

    // Macrominerals (milligrams)
    const NutritionCategory(
      title: 'Macrominerals (milligrams)',
      unit: 'mg',
      items: [
        NutritionItem(name: 'Calcium', value: 250, unit: 'mg'),
        NutritionItem(name: 'Phosphorus', value: 320, unit: 'mg'),
        NutritionItem(name: 'Magnesium', value: 115, unit: 'mg'),
        NutritionItem(name: 'Sodium', value: 580, unit: 'mg'),
        NutritionItem(name: 'Potassium', value: 480, unit: 'mg'),
      ],
    ),

    // Microminerals (milligrams)
    const NutritionCategory(
      title: 'Microminerals (milligrams)',
      unit: 'mg',
      items: [
        NutritionItem(name: 'Iron', value: 3.8, unit: 'mg'),
        NutritionItem(name: 'Zinc', value: 2.5, unit: 'mg'),
        NutritionItem(name: 'Copper', value: 0.4, unit: 'mg'),
        NutritionItem(name: 'Manganese', value: 1.2, unit: 'mg'),
      ],
    ),

    // Microminerals (micrograms)
    const NutritionCategory(
      title: 'Microminerals (micrograms)',
      unit: 'mcg',
      items: [
        NutritionItem(name: 'Selenium', value: 55, unit: 'mcg'),
        NutritionItem(name: 'Iodine', value: 35, unit: 'mcg'),
        NutritionItem(name: 'Chromium', value: 12, unit: 'mcg'),
        NutritionItem(name: 'Molybdenum', value: 25, unit: 'mcg'),
      ],
    ),
  ];
});
