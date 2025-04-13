import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/food_item.dart';
import '../services/fatsecret_service.dart';

final foodSwapsProvider =
    AsyncNotifierProvider<FoodSwapsNotifier, List<FoodItem>>(() {
  return FoodSwapsNotifier();
});

class FoodSwapsNotifier extends AsyncNotifier<List<FoodItem>> {
  final _fatSecretService = FatSecretService();

  @override
  Future<List<FoodItem>> build() async {
    return [];
  }

  Future<void> searchAlternativeFoods(String foodName) async {
    state = const AsyncValue.loading();
    try {
      // Initialize the service if needed
      await _fatSecretService.initialize();

      // Search for alternative foods
      final alternative = await _fatSecretService.searchFoodByName(foodName);

      // Update the state with the alternatives, wrapping in a list
      state = AsyncValue.data(alternative != null ? [alternative] : []);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void clearAlternatives() {
    state = const AsyncValue.data([]);
  }
}
