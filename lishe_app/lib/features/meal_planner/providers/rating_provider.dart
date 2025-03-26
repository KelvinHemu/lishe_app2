import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model to store ratings
class RatingState {
  final Map<String, double> mealRatings;

  const RatingState({this.mealRatings = const {}});

  RatingState copyWith({Map<String, double>? mealRatings}) {
    return RatingState(mealRatings: mealRatings ?? this.mealRatings);
  }
}

// Provider state notifier
class RatingNotifier extends StateNotifier<RatingState> {
  RatingNotifier() : super(const RatingState());

  // Get rating for a specific meal
  double getMealRating(String mealId) {
    return state.mealRatings[mealId] ?? 0.0;
  }

  // Set rating for a meal
  void setMealRating(String mealId, double rating) {
    final updatedRatings = Map<String, double>.from(state.mealRatings);
    updatedRatings[mealId] = rating;
    state = state.copyWith(mealRatings: updatedRatings);

    // Here you would typically also make an API call to store the rating
    _saveRatingToBackend(mealId, rating);
  }

  // Mock function to simulate saving to backend
  Future<void> _saveRatingToBackend(String mealId, double rating) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 300));

    // In a real app, you would make an actual API call here
  }

  // Load initial ratings (e.g., from local storage or API)
  Future<void> loadRatings() async {
    // Simulate loading from API
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data
    final Map<String, double> initialRatings = {
      'meal1': 4.5,
      'meal2': 3.0,
      'meal3': 5.0,
    };

    state = state.copyWith(mealRatings: initialRatings);
  }
}

// Create the provider
final ratingProvider = StateNotifierProvider<RatingNotifier, RatingState>((
  ref,
) {
  final notifier = RatingNotifier();
  // Load initial data
  notifier.loadRatings();
  return notifier;
});

// Convenience provider to get rating for a specific meal
final mealRatingProvider = Provider.family<double, String>((ref, mealId) {
  final ratingState = ref.watch(ratingProvider);
  return ratingState.mealRatings[mealId] ?? 0.0;
});
