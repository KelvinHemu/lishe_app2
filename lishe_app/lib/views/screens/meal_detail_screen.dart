import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/meal.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/top_app_bar.dart';
import '../widgets/rating_stars_widget.dart';
import '../../providers/rating_provider.dart';
import '../../providers/meal_detail_provider.dart';
import '../../providers/nutrition_provider.dart'; // Add this import
import '../widgets/meal/meal_action_buttons.dart';
import '../widgets/nutrition_info_card.dart'; // Add this import
import '../../models/app_bar_model.dart';
import '../../models/nutrition_data.dart'; // Add this import

class MealDetailScreen extends ConsumerWidget {
  final Meal meal;

  const MealDetailScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current rating for this meal
    final rating = ref.watch(mealRatingProvider(meal.id));

    // Watch the selected tab
    final selectedTab = ref.watch(selectedMealTabProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Meal Details',
        actions: [
          AppBarItem(
            icon: Icons.favorite_border,
            label: 'Favorite',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added to favorites!')),
              );
            },
          ),
          AppBarItem(
            icon: Icons.share,
            label: 'Share',
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Sharing meal...')));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header image
            SizedBox(
              height: 250,
              width: double.infinity,
              child: _buildHeaderImage(),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title section with interactive rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          meal.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      RatingStarsWidget(
                        rating: rating > 0 ? rating : 4.0,
                        size: 24,
                        isInteractive: true,
                        onRatingChanged: (newRating) {
                          ref
                              .read(ratingProvider.notifier)
                              .setMealRating(meal.id, newRating);
                        },
                      ),
                    ],
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
                        _ => MealDetailTab.nutrients,
                      };

                      // Update the selected tab
                      ref.read(selectedMealTabProvider.notifier).state = tab;

                      // Show feedback
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Viewing ${buttonId.toLowerCase()}'),
                          duration: const Duration(milliseconds: 800),
                        ),
                      );
                    },
                    defaultExpandedButton: 'nutrients',
                  ),

                  const SizedBox(height: 16),

                  // Content container based on selected tab
                  _buildContentForTab(selectedTab, meal),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildContentForTab(MealDetailTab tab, Meal meal) {
    return switch (tab) {
      MealDetailTab.ingredients => _buildIngredientsContent(meal),
      MealDetailTab.nutrients => _buildNutrientsContent(meal),
      MealDetailTab.weight => _buildWeightContent(meal),
      MealDetailTab.about => _buildAboutContent(meal),
    };
  }

  Widget _buildIngredientsContent(Meal meal) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingredients',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text('Coming soon: List of ingredients for ${meal.name}'),
        ],
      ),
    );
  }

  Widget _buildNutrientsContent(Meal meal) {
    return Consumer(
      builder: (context, ref, child) {
        final nutritionData = ref.watch(mealNutritionProvider(meal.id));

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nutritional Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              nutritionData.when(
                loading:
                    () => const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                error:
                    (error, stack) =>
                        Text('Error loading nutrition data: $error'),
                data:
                    (categories) => Column(
                      children:
                          categories
                              .map(
                                (category) => _buildNutritionCategory(category),
                              )
                              .toList(),
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNutritionCategory(NutritionCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            category.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        ),
        _buildNutritionTable(category),
        const Divider(height: 32),
      ],
    );
  }

  Widget _buildNutritionTable(NutritionCategory category) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            (category.items.length / 2).ceil(), // Get number of rows needed
            (rowIndex) {
              final startIndex = rowIndex * 2;
              return Row(
                children: [
                  // First item in row
                  Expanded(
                    child: NutritionInfoCard(
                      title: category.items[startIndex].name,
                      value: category.items[startIndex].value.toString(),
                      unit: category.items[startIndex].unit,
                      icon: _getNutritionIcon(category.items[startIndex].name),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Second item in row (if exists)
                  Expanded(
                    child:
                        startIndex + 1 < category.items.length
                            ? NutritionInfoCard(
                              title: category.items[startIndex + 1].name,
                              value:
                                  category.items[startIndex + 1].value
                                      .toString(),
                              unit: category.items[startIndex + 1].unit,
                              icon: _getNutritionIcon(
                                category.items[startIndex + 1].name,
                              ),
                            )
                            : Container(), // Empty container for odd number of items
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // Helper method to get appropriate icons for nutrition items
  IconData _getNutritionIcon(String nutritionName) {
    return switch (nutritionName.toLowerCase()) {
      'calories' => Icons.local_fire_department,
      'protein' => Icons.fitness_center,
      'carbohydrates' => Icons.grain,
      'fat' => Icons.opacity,
      'fiber' => Icons.grass,
      'sugar' => Icons.cookie,
      'vitamin a' => Icons.visibility,
      'vitamin c' => Icons.battery_charging_full,
      'vitamin d' => Icons.wb_sunny,
      'vitamin e' => Icons.medical_services,
      'vitamin k' => Icons.healing,
      'calcium' => Icons.bike_scooter,
      'iron' => Icons.fitness_center,
      'zinc' => Icons.psychology,
      _ => Icons.science,
    };
  }

  Widget _buildWeightContent(Meal meal) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weight Information',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text('Coming soon: Weight and portion details for ${meal.name}'),
        ],
      ),
    );
  }

  Widget _buildAboutContent(Meal meal) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About This Meal',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text('Coming soon: Description and details for ${meal.name}'),
        ],
      ),
    );
  }

  // Keep your existing header image methods
  Widget _buildHeaderImage() {
    // Check if image URL is network or asset
    final bool isNetworkImage = meal.imageUrl.startsWith('http');

    if (isNetworkImage) {
      return Image.network(
        meal.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey.shade200,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      );
    } else {
      return Image.asset(
        meal.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
      );
    }
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey.shade300,
      child: const Center(
        child: Icon(Icons.restaurant, size: 80, color: Colors.grey),
      ),
    );
  }
}
