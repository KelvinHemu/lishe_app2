import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the possible tab options
enum MealDetailTab { ingredients, nutrients, weight, about }

// Create a provider for the selected tab
final selectedMealTabProvider = StateProvider<MealDetailTab>((ref) {
  return MealDetailTab.nutrients; // Default to nutrients tab
});
