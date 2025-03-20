import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lishe_app/views/widgets/meal_planner/meal_of_the_day_card.dart';
import '../../models/meal.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/top_app_bar.dart';
import '../widgets/rating_stars_widget.dart';
import '../../providers/rating_provider.dart';
import '../../providers/meal_detail_provider.dart';
import '../widgets/meal/meal_action_buttons.dart';
import '../../models/app_bar_model.dart';
import '../widgets/meal/meal_about_widget.dart';
import '../widgets/meal/meal_nutrients_widget.dart';
import '../widgets/meal/meal_ingredients_widget.dart';
import '../widgets/meal/meal_weight_widget.dart';
import '../widgets/meal_planner/food_picture_widget.dart'; // Add this import

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
            SizedBox(child: _buildHeaderImage()),
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
      MealDetailTab.ingredients => MealIngredientsWidget(meal: meal),
      MealDetailTab.nutrients => MealNutrientsWidget(meal: meal),
      MealDetailTab.weight => MealWeightWidget(meal: meal),
      MealDetailTab.about => MealAboutWidget(meal: meal),
    };
  }

  Widget _buildHeaderImage() {
    return MealOfTheDayCard(
      meal: meal,
      // No onTap needed since we're already in the meal detail screen
      onTap: null,
    );
  }
}
