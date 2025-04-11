import 'package:flutter/material.dart';
import '../models/food_item.dart';

class FoodNutritionCard extends StatelessWidget {
  final FoodItem foodItem;

  const FoodNutritionCard({
    super.key,
    required this.foodItem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food Name
            Text(
              foodItem.foodName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (foodItem.brandName.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                foodItem.brandName,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            // Nutrition Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNutrientInfo(
                    'Calories', foodItem.calories, 'kcal', Colors.red),
                _buildNutrientInfo(
                    'Protein', foodItem.protein, 'g', Colors.green),
                _buildNutrientInfo('Carbs', foodItem.carbs, 'g', Colors.blue),
                _buildNutrientInfo('Fat', foodItem.fat, 'g', Colors.amber),
              ],
            ),
            const SizedBox(height: 8),
            // Serving Size
            Text(
              'Per ${foodItem.servingSize ?? ""} ${foodItem.servingUnit}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientInfo(
      String label, double? value, String unit, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value != null ? '${value.toStringAsFixed(1)} $unit' : '-- $unit',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
