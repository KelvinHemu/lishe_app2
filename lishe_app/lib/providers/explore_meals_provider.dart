import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lishe_app/models/meal.dart';
import '../controllers/explore_meals_controller.dart';

// Define the provider with the correct spelling
final exploreMealsControllerProvider =
    StateNotifierProvider<ExploreMealsController, ExploreMealsState>(
      (ref) => ExploreMealsController(),
    );

final filteredMealsProvider = Provider<List<Meal>>((ref) {
  final state = ref.watch(exploreMealsControllerProvider);
  final meals = state.meals;
  final searchQuery = state.searchQuery.toLowerCase();
  final category = state.selectedCategory;
  final dietType = state.selectedDietType;
  final mealTypes = state.selectedMealTypes;

  return meals.where((meal) {
    // Category filter
    final matchesCategory = category.isEmpty || meal.category == category;

    // Search filter
    final matchesSearch =
        searchQuery.isEmpty ||
        meal.name.toLowerCase().contains(searchQuery) ||
        (meal.description.toLowerCase().contains(searchQuery));

    // Diet type filter
    final matchesDietType =
        dietType == 'Any' || _matchesDietType(meal, dietType);

    // Meal type filter
    final matchesMealType =
        mealTypes.isEmpty ||
        mealTypes.any((type) => meal.mealTypes.contains(type));

    return matchesCategory &&
        matchesSearch &&
        matchesDietType &&
        matchesMealType;
  }).toList();
});

bool _matchesDietType(Meal meal, String dietType) {
  switch (dietType) {
    case 'Vegetarian':
      return !meal.ingredients.any(
        (ingredient) =>
            ingredient.toLowerCase().contains('meat') ||
            ingredient.toLowerCase().contains('chicken') ||
            ingredient.toLowerCase().contains('beef'),
      );
    case 'High Protein':
      return meal.protein > 20;
    case 'Low Carb':
      return meal.carbs < 30;
    case 'Low Calorie':
      return meal.calories < 300;
    default:
      return true;
  }
}
