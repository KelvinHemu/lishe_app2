import 'package:flutter/material.dart';
import '../../../controllers/meal_planner_controller.dart';
import 'meal_type_selector.dart';

class CurrentMealWidget extends StatelessWidget {
  final MealPlannerController controller;

  const CurrentMealWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentHour = now.hour;

    String mealType;

    // Determine current meal based on time of day
    if (currentHour >= 5 && currentHour < 11) {
      mealType = "breakfast";
    } else if (currentHour >= 11 && currentHour < 16) {
      mealType = "lunch";
    } else {
      mealType = "dinner";
    }

    return Column(
      children: [
        // Simple meal type text labels
        MealTypeSelector(currentMealType: mealType),
        const SizedBox(height: 16),
        // Meal details container
        // MealDetailsContainer(currentMeal: currentMeal, mealType: mealType),
      ],
    );
  }
}
