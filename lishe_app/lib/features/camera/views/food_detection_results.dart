import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/food_item.dart';
import '../models/food_detection_result.dart';
import '../providers/food_nutrition_provider.dart';
import '../widgets/food_nutrition_widget.dart';
import '../widgets/food_item_header.dart';
import '../widgets/camera_action_buttons.dart';
import '../widgets/food_swaps_widget.dart';
import '../../meal_planner/widgets/meal/meal_about_widget.dart';
import '../../meal_planner/widgets/meal/meal_weight_widget.dart';
import '../../meal_planner/widgets/meal/meal_map_widget.dart';
import '../../meal_planner/providers/meal_detail_provider.dart';
import '../../meal_planner/models/meal.dart';
import '../../meal_planner/models/nutrition_data.dart';

// Provider for the currently selected food item
final selectedFoodProvider = StateProvider<FoodItem?>((ref) => null);

class FoodDetectionResults extends ConsumerWidget {
  final List<FoodItem> foodItems;
  final List<DetectedFood> detectedFoods;
  final VoidCallback onRetake;

  const FoodDetectionResults({
    super.key,
    required this.foodItems,
    required this.detectedFoods,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (foodItems.isEmpty) {
      return _buildEmptyState(context);
    }

    // Get the first food item for now (we can expand to show multiple items later)
    final foodItem = foodItems.first;
    final nutritionData = ref.watch(foodNutritionProvider(foodItem));
    final selectedTab = ref.watch(selectedMealTabProvider);

    // Convert FoodItem to Meal format for the widgets
    final meal = Meal(
      id: foodItem.foodId,
      name: foodItem.foodName,
      calories: foodItem.calories?.round() ?? 0,
      protein: foodItem.protein ?? 0,
      carbs: foodItem.carbs ?? 0,
      fat: foodItem.fat ?? 0,
      imageUrl: foodItem.foodImageUrl ?? '',
      ingredients: [], // FoodItem doesn't have ingredients
      recipe: '', // FoodItem doesn't have recipe
      mealTypes: [foodItem.foodType],
      category: foodItem.foodType,
      difficulty: 'Medium',
      description: _buildFoodDescription(foodItem),
      weight: foodItem.servingSize?.round() ?? 0,
      servingSize: 1,
      preparationTime: 'N/A',
    );

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food item header with small circular image
            FoodItemHeader(foodItem: foodItem),

            // CameraActionButtons widget
            CameraActionButtons(
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
                ref.read(selectedMealTabProvider.notifier).state = tab;
              },
              defaultExpandedButton: 'nutrients',
            ),

            // Content area based on selected tab
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: switch (selectedTab) {
                MealDetailTab.ingredients => FoodSwapsWidget(
                    foodItems: foodItems,
                    detectedFoods: detectedFoods,
                    onFoodSelected: (selectedFood) {
                      // Update the selected food item
                      ref.read(selectedFoodProvider.notifier).state =
                          selectedFood;
                    },
                  ),
                MealDetailTab.nutrients => nutritionData.when(
                    data: (data) => FoodNutritionWidget(
                      nutritionCategories: data,
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, stackTrace) => Center(
                      child: Text('Error loading nutrition data: $error'),
                    ),
                  ),
                MealDetailTab.weight => MealWeightWidget(meal: meal),
                MealDetailTab.about => MealAboutWidget(meal: meal),
                MealDetailTab.map => MealMapWidget(meal: meal),
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentForTab(
    MealDetailTab tab,
    Meal meal,
    AsyncValue<List<NutritionCategory>> nutritionData,
    List<FoodItem> foodItems,
    List<DetectedFood> detectedFoods,
  ) {
    return switch (tab) {
      MealDetailTab.ingredients => FoodSwapsWidget(
          foodItems: foodItems,
          detectedFoods: detectedFoods,
          onFoodSelected: (selectedFood) {
            // Handle food selection
            // You can update the UI or perform other actions here
          },
        ),
      MealDetailTab.nutrients => nutritionData.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Error loading nutrition data: $error'),
          ),
          data: (categories) => FoodNutritionWidget(
            nutritionCategories: categories,
          ),
        ),
      MealDetailTab.weight => MealWeightWidget(meal: meal),
      MealDetailTab.about => MealAboutWidget(meal: meal),
      MealDetailTab.map => MealMapWidget(meal: meal),
    };
  }

  String _buildFoodDescription(FoodItem foodItem) {
    final description = StringBuffer();

    // Basic information
    description.writeln('${foodItem.foodName} is a ${foodItem.foodType} food.');
    if (foodItem.brandName != null) {
      description.writeln('Brand: ${foodItem.brandName}');
    }

    // Serving information
    description.writeln(
        '\nServing Size: ${foodItem.servingSize} ${foodItem.servingUnit}');

    // Nutritional highlights
    description.writeln('\nNutritional Highlights:');
    if (foodItem.calories != null) {
      description.writeln('• Calories: ${foodItem.calories} kcal');
    }
    if (foodItem.protein != null) {
      description.writeln('• Protein: ${foodItem.protein}g');
    }
    if (foodItem.carbs != null) {
      description.writeln('• Carbohydrates: ${foodItem.carbs}g');
    }
    if (foodItem.fat != null) {
      description.writeln('• Fat: ${foodItem.fat}g');
    }

    return description.toString();
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.no_food,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No foods detected',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Try taking another photo',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetake,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Take Photo'),
          ),
        ],
      ),
    );
  }
}
