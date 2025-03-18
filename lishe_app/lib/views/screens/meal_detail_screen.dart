import 'package:flutter/material.dart';
import '../../models/meal.dart';
import '../widgets/custom_button.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/top_app_bar.dart';

import '../../models/app_bar_model.dart';

class MealDetailScreen extends StatelessWidget {
  final Meal meal;

  const MealDetailScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
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
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Tags/categories
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildTag('${meal.calories} cal'),
                      _buildTag(meal.category),
                      _buildTag(meal.difficulty),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Description
                  const Text(
                    'About this meal',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    meal.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),

                  const SizedBox(height: 24),

                  // Ingredients section
                  const Text(
                    'Ingredients',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._buildIngredientsList(),

                  const SizedBox(height: 24),

                  // Nutritional information
                  const Text(
                    'Nutritional Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildNutritionalInfo(),

                  const SizedBox(height: 24),

                  // Action button
                  CustomButton(
                    text: 'Add to My Meal Plan',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Added to your meal plan!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  ),
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

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.green.shade800,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildNutritionalInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNutrientColumn('Calories', '${meal.calories}', 'kcal'),
          _buildNutrientColumn('Protein', '${meal.protein}', 'g'),
          _buildNutrientColumn('Carbs', '${meal.carbs}', 'g'),
          _buildNutrientColumn('Fat', '${meal.fat}', 'g'),
        ],
      ),
    );
  }

  Widget _buildNutrientColumn(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(unit, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
      ],
    );
  }

  List<Widget> _buildIngredientsList() {
    // Use actual ingredients from meal if available, otherwise use mock data
    final List<String> ingredients =
        meal.ingredients.isNotEmpty
            ? meal.ingredients
            : [
              '2 cups of rice',
              '1 tablespoon olive oil',
              '1 onion, diced',
              '2 cloves garlic, minced',
              '1 bell pepper, chopped',
              'Salt and pepper to taste',
            ];

    return ingredients.map((ingredient) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Icon(Icons.circle, size: 8, color: Colors.green.shade800),
            const SizedBox(width: 12),
            Expanded(
              child: Text(ingredient, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      );
    }).toList();
  }
}
