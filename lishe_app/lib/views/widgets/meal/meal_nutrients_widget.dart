import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/meal.dart';
import '../../../models/nutrition_data.dart';
import '../../../providers/nutrition_provider.dart';
import '../nutrition_info_card.dart';

class MealNutrientsWidget extends ConsumerWidget {
  final Meal meal;

  const MealNutrientsWidget({super.key, required this.meal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                (error, stack) => Text('Error loading nutrition data: $error'),
            data:
                (categories) => Column(
                  children:
                      categories
                          .map((category) => _buildNutritionCategory(category))
                          .toList(),
                ),
          ),
        ],
      ),
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
              color: Color.fromARGB(255, 58, 60, 58),
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
          children: List.generate((category.items.length / 2).ceil(), (
            rowIndex,
          ) {
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
                                category.items[startIndex + 1].value.toString(),
                            unit: category.items[startIndex + 1].unit,
                            icon: _getNutritionIcon(
                              category.items[startIndex + 1].name,
                            ),
                          )
                          : Container(), // Empty container for odd number of items
                ),
              ],
            );
          }),
        );
      },
    );
  }

  // Helper method to get appropriate icons for nutrition items
  IconData _getNutritionIcon(String nutritionName) {
    return switch (nutritionName.toLowerCase()) {
      'calories' => Icons.local_fire_department,
      'protein' => Icons.fitness_center,
      'carbohydrates' || 'carbs' => Icons.grain,
      'fat' => Icons.opacity,
      'fiber' => Icons.grass,
      'sugar' => Icons.cookie,
      'vit a' || 'vitamin a' => Icons.visibility,
      'vit c' || 'vitamin c' => Icons.battery_charging_full,
      'vit d' || 'vitamin d' => Icons.wb_sunny,
      'vit e' || 'vitamin e' => Icons.medical_services,
      'vit k' || 'vitamin k' => Icons.healing,
      'ca' || 'calcium' => Icons.bike_scooter,
      'fe' || 'iron' => Icons.fitness_center,
      'zn' || 'zinc' => Icons.psychology,
      _ => Icons.science,
    };
  }
}
