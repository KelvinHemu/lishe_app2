import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meal.dart';
import '../services/mock_meal_service.dart';

// Define your state class
class ExploreMealsState {
  final List<Meal> meals;
  final bool isLoading;
  final String? error;
  final bool hasMoreMeals;
  final String selectedCategory; // Add this field

  ExploreMealsState({
    this.meals = const [],
    this.isLoading = false,
    this.error,
    this.hasMoreMeals = true,
    this.selectedCategory = '', // Default to empty string (all categories)
  });

  ExploreMealsState copyWith({
    List<Meal>? meals,
    bool? isLoading,
    String? error,
    bool? hasMoreMeals,
    String? selectedCategory,
  }) {
    return ExploreMealsState(
      meals: meals ?? this.meals,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      hasMoreMeals: hasMoreMeals ?? this.hasMoreMeals,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

// Implement the controller as a StateNotifier
class ExploreMealsController extends StateNotifier<ExploreMealsState> {
  final MockMealService _mealService = MockMealService();

  ExploreMealsController() : super(ExploreMealsState());

  // Add the missing method
  void updateSelectedCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  Future<void> loadInitialMeals() async {
    state = state.copyWith(isLoading: true);

    try {
      // Reset pagination

      // Get initial batch of meals
      final meals = _mealService.getAllMockMeals();

      state = state.copyWith(
        meals: meals,
        isLoading: false,
        hasMoreMeals: meals.length >= 10, // Assuming batch size is 10
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMoreMeals() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);

    try {
      // In a real app, you would fetch the next page
      // For now, simulate with a delay and some more meals
      await Future.delayed(const Duration(milliseconds: 800));

      // Get more meals - in a real app this would use pagination
      final moreMeals = _mealService.getAllMockMeals();

      // Determine if we have more pages
      final hasMore = moreMeals.isNotEmpty;

      state = state.copyWith(
        meals: [...state.meals, ...moreMeals],
        isLoading: false,
        hasMoreMeals: hasMore,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
