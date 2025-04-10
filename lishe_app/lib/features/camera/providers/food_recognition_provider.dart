import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/food_item.dart';
import '../services/fatsecret_service.dart';

/// State class for food recognition
class FoodRecognitionState {
  final List<FoodItem> foods;
  final String? error;
  final bool isLoading;

  const FoodRecognitionState({
    this.foods = const [],
    this.error,
    this.isLoading = false,
  });

  FoodRecognitionState copyWith({
    List<FoodItem>? foods,
    String? error,
    bool? isLoading,
  }) {
    return FoodRecognitionState(
      foods: foods ?? this.foods,
      error: error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Provider for food recognition state
class FoodRecognitionNotifier extends StateNotifier<FoodRecognitionState> {
  final FatSecretService _fatSecretService;

  FoodRecognitionNotifier(this._fatSecretService)
      : super(const FoodRecognitionState());

  /// Process text from image recognition
  Future<void> processImageText(String text) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Split text into potential food items
      final foodItems = text.split(RegExp(r'[\n,]+'));

      // Process each potential food item
      final List<FoodItem> recognizedFoods = [];
      for (final item in foodItems) {
        final trimmedItem = item.trim();
        if (trimmedItem.isNotEmpty) {
          final food = await _fatSecretService.searchFoodByName(trimmedItem);
          if (food != null) {
            recognizedFoods.add(food);
          }
        }
      }

      state = state.copyWith(
        foods: recognizedFoods,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to recognize food: $e',
        isLoading: false,
      );
    }
  }

  /// Clear the current state
  void clear() {
    state = const FoodRecognitionState();
  }
}

/// Provider for food recognition
final foodRecognitionProvider =
    StateNotifierProvider<FoodRecognitionNotifier, FoodRecognitionState>((ref) {
  final fatSecretService = FatSecretService();
  return FoodRecognitionNotifier(fatSecretService);
});
