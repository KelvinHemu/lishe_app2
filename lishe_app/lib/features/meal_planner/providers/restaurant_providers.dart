import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/restaurant.dart';
import '../models/meal.dart';
import '../services/restaurant_service.dart';

// State class
class RestaurantsState {
  final List<Restaurant> restaurants;
  final bool isLoading;
  final String? errorMessage;

  RestaurantsState({
    this.restaurants = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  RestaurantsState copyWith({
    List<Restaurant>? restaurants,
    bool? isLoading,
    String? errorMessage,
  }) {
    return RestaurantsState(
      restaurants: restaurants ?? this.restaurants,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Notifier that manages restaurant state
class RestaurantsNotifier extends StateNotifier<RestaurantsState> {
  final RestaurantService _restaurantService;

  RestaurantsNotifier(this._restaurantService) : super(RestaurantsState());

  Future<void> fetchRestaurantsForMeal(String mealName) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final restaurants = await _restaurantService.getNearbyRestaurants(
        mealName,
      );

      state = state.copyWith(restaurants: restaurants, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load restaurants: ${e.toString()}',
      );
    }
  }
}

// Restaurant service provider
final restaurantServiceProvider = Provider<RestaurantService>((ref) {
  return RestaurantService();
});

// Restaurant state notifier provider
final restaurantsProvider =
    StateNotifierProvider.family<RestaurantsNotifier, RestaurantsState, Meal>((
      ref,
      meal,
    ) {
      final restaurantService = ref.watch(restaurantServiceProvider);
      final notifier = RestaurantsNotifier(restaurantService);

      // Initial fetch when provider is created
      notifier.fetchRestaurantsForMeal(meal.name);

      return notifier;
    });
