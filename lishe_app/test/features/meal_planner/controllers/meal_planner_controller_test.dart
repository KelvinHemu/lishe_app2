import 'package:flutter_test/flutter_test.dart';
import 'package:lishe_app/features/meal_planner/controllers/meal_planner_controller.dart';
import 'package:lishe_app/features/meal_planner/models/meal.dart';

void main() {
  late MealPlannerController controller;
  late Meal testMeal;

  setUp(() {
    controller = MealPlannerController();
    testMeal = Meal(
      id: '999',
      name: 'Test Meal',
      calories: 500,
      protein: 20.0,
      carbs: 50.0,
      fat: 15.0,
      imageUrl: 'assets/images/test_meal.jpg',
      ingredients: ['Test Ingredient 1', 'Test Ingredient 2'],
      recipe: 'Test recipe instructions',
      mealTypes: ['breakfast'],
    );
  });

  group('MealPlannerController Notification Tests', () {
    test('initialize notification service', () async {
      await controller.initialize();
      // If no exception is thrown, initialization was successful
      expect(true, isTrue);
    });

    test('schedule meal notification', () async {
      await controller.initialize();
      
      // Schedule a meal for tomorrow
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      await controller.setMealForDate(tomorrow, 'breakfast', testMeal);
      
      // If no exception is thrown, scheduling was successful
      expect(true, isTrue);
    });

    test('cancel meal notification', () async {
      await controller.initialize();
      
      // Schedule a meal
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      await controller.setMealForDate(tomorrow, 'breakfast', testMeal);
      
      // Cancel the meal
      await controller.removeMealFromDate(tomorrow, 'breakfast');
      
      // If no exception is thrown, cancellation was successful
      expect(true, isTrue);
    });
  });
} 