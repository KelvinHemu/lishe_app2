import 'package:flutter/material.dart';
import '../../controllers/meal_planner_controller.dart';
import 'meal_type_selector.dart';

class CurrentMealWidget extends StatelessWidget {
  final MealPlannerController controller;
  final DateTime selectedDate;
  final Function(String) onMealTap;

  const CurrentMealWidget({
    super.key,
    required this.controller,
    required this.selectedDate,
    required this.onMealTap,
  });

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

    return MealTypeSelector(
      currentMealType: mealType,
      controller: controller,
      selectedDate: selectedDate,
      onMealTap: onMealTap,
    );
  }
}
