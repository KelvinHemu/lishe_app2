import 'package:flutter/material.dart';
import '../../meal_planner/models/nutrition_data.dart';
import '../../../../core/common/widgets/nutrition_info_card.dart';

class FoodNutritionWidget extends StatelessWidget {
  final List<NutritionCategory> nutritionCategories;

  const FoodNutritionWidget({
    super.key,
    required this.nutritionCategories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...nutritionCategories
              .map((category) => _buildNutritionCategory(category)),
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
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(8),
          child: _buildNutritionTable(category),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildNutritionTable(NutritionCategory category) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              List.generate((category.items.length / 2).ceil(), (rowIndex) {
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
                  child: startIndex + 1 < category.items.length
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
