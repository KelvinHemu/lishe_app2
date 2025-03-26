import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lishe_app/features/meal_planner/widgets/meal/meal_map_widget.dart';
import 'package:lishe_app/features/meal_planner/widgets/meal_planner/meal_of_the_day_card.dart';
import '../models/meal.dart';
import '../../../core/common/widgets/bottom_nav_bar.dart';
import '../../../core/common/widgets/top_app_bar.dart';
import '../providers/meal_detail_provider.dart';
import '../widgets/meal/meal_action_buttons.dart';
import '../models/app_bar_model.dart';
import '../widgets/meal/meal_about_widget.dart';
import '../widgets/meal/meal_nutrients_widget.dart';
import '../widgets/recipe/meal_ingredients_widget.dart';
import '../widgets/meal/meal_weight_widget.dart';

class MealDetailScreen extends ConsumerWidget {
  final Meal meal;

  const MealDetailScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the selected tab
    final selectedTab = ref.watch(selectedMealTabProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: 'Meal Details',
        actions: [
          AppBarItem(
            icon: Icons.bookmark_add_outlined,
            label: 'Favorite',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added to bookmark')),
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
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [const SizedBox(width: 8)],
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
                        'map' => MealDetailTab.map, // Add this line
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
      MealDetailTab.map => MealMapWidget(meal: meal), // Add this line
    };
  }

  Widget _buildHeaderImage() {
    return MealOfTheDayCard(
      meal: meal,
      onTap: null,
      showHeader: true, // Set to true to show the new header row
    );
  }
}
