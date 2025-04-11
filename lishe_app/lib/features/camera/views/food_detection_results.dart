import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/food_item.dart';
import '../widgets/food_nutrition_card.dart';
import '../../meal_planner/widgets/meal/meal_action_buttons.dart';
import '../../meal_planner/widgets/meal/meal_about_widget.dart';
import '../../meal_planner/widgets/meal/meal_nutrients_widget.dart';
import '../../meal_planner/widgets/recipe/meal_ingredients_widget.dart';
import '../../meal_planner/widgets/meal/meal_weight_widget.dart';
import '../../meal_planner/providers/meal_detail_provider.dart';
import '../../meal_planner/models/meal.dart';
import '../../meal_planner/widgets/meal/meal_map_widget.dart';

class FoodDetectionResults extends ConsumerWidget {
  final List<FoodItem> foodItems;
  final VoidCallback onRetake;

  const FoodDetectionResults({
    super.key,
    required this.foodItems,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the selected tab
    final selectedTab = ref.watch(selectedMealTabProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          foodItems.isEmpty
              ? 'No Foods Detected'
              : 'Detected Foods (${foodItems.length})',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: onRetake,
            tooltip: 'Take another photo',
          ),
        ],
      ),
      body: foodItems.isEmpty
          ? _buildEmptyState(context)
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header image
                  SizedBox(
                    height: 300,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Food image
                        if (foodItems.isNotEmpty &&
                            foodItems[0].foodImageUrl != null)
                          Image.network(
                            foodItems[0].foodImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.restaurant,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        else
                          Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.restaurant,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        // Overlay gradient
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        // Food name
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                foodItems[0].foodName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (foodItems[0].brandName.isNotEmpty)
                                Text(
                                  foodItems[0].brandName,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 16,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [SizedBox(width: 8)],
                        ),
                        const SizedBox(height: 8),

                        // MealActionButtons widget
                        MealActionButtons(
                          onButtonTap: (buttonId) {
                            // Map the button ID to the corresponding enum value
                            final tab = switch (buttonId) {
                              'ingredients' => MealDetailTab.ingredients,
                              'nutrients' => MealDetailTab.nutrients,
                              'weight' => MealDetailTab.weight,
                              'about' => MealDetailTab.about,
                              'map' => MealDetailTab.map,
                              _ => MealDetailTab.nutrients,
                            };

                            // Update the selected tab
                            ref.read(selectedMealTabProvider.notifier).state =
                                tab;
                          },
                          defaultExpandedButton: 'nutrients',
                        ),

                        const SizedBox(height: 16),

                        // Content container based on selected tab
                        _buildContentForTab(selectedTab, foodItems[0]),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildContentForTab(MealDetailTab tab, FoodItem foodItem) {
    // Convert FoodItem to Meal format for the widgets
    final meal = Meal(
      id: foodItem
          .foodName, // Use food name as ID since FoodItem doesn't have an ID
      name: foodItem.foodName,
      calories: foodItem.calories?.round() ?? 0,
      protein: foodItem.protein ?? 0,
      carbs: foodItem.carbs ?? 0,
      fat: foodItem.fat ?? 0,
      imageUrl: foodItem.foodImageUrl ?? '',
      ingredients: [], // FoodItem doesn't have ingredients
      recipe: '', // FoodItem doesn't have recipe
      mealTypes: [],
      category: '', // FoodItem doesn't have category
      difficulty: 'Medium',
      description: '', // FoodItem doesn't have description
      weight: foodItem.servingSize?.round() ?? 0,
      servingSize: 1,
      preparationTime: 'N/A',
    );

    return switch (tab) {
      MealDetailTab.ingredients => MealIngredientsWidget(meal: meal),
      MealDetailTab.nutrients => MealNutrientsWidget(meal: meal),
      MealDetailTab.weight => MealWeightWidget(meal: meal),
      MealDetailTab.about => MealAboutWidget(meal: meal),
      MealDetailTab.map => MealMapWidget(meal: meal),
    };
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.no_food,
                size: 80,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'No food items detected',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Try taking another photo with clearer visibility of the food',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetake,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take Another Photo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
