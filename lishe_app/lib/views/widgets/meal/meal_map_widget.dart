import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../models/meal.dart';
import '../../../models/restaurant.dart';
import '../../../providers/restaurant_providers.dart';
import 'restaurant_card.dart';

class MealMapWidget extends ConsumerWidget {
  final Meal meal;

  const MealMapWidget({super.key, required this.meal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the restaurants state for this specific meal
    final restaurantsState = ref.watch(restaurantsProvider(meal));

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),

          // Show loading, error or restaurants grid
          if (restaurantsState.isLoading)
            const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Finding nearby restaurants...'),
                ],
              ),
            )
          else if (restaurantsState.errorMessage != null)
            _buildErrorView(context, restaurantsState.errorMessage!, ref)
          else if (restaurantsState.restaurants.isEmpty)
            _buildEmptyView(context)
          else
            _buildRestaurantsGrid(context, restaurantsState.restaurants),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Find ${meal.name} Nearby',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 8),
          PhosphorIcon(
            PhosphorIcons.mapPin(),
            size: 25,
            color: Colors.red.shade700,
            weight: 200,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(
    BuildContext context,
    String errorMessage,
    WidgetRef ref,
  ) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(restaurantsProvider(meal).notifier)
                  .fetchRestaurantsForMeal(meal.name);
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.restaurant_outlined,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No restaurants serving ${meal.name} found nearby',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantsGrid(
    BuildContext context,
    List<Restaurant> restaurants,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.8,
      children:
          restaurants
              .map(
                (restaurant) => RestaurantCard(
                  restaurant: restaurant,
                  onTap: () {
                    // You could add navigation to restaurant details here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Selected ${restaurant.name}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              )
              .toList(),
    );
  }
}
