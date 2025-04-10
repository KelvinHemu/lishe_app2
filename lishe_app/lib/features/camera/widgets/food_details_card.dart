import 'package:flutter/material.dart';
import '../models/food_item.dart';

class FoodDetailsCard extends StatelessWidget {
  final FoodItem food;

  const FoodDetailsCard({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food name and brand
            Row(
              children: [
                Expanded(
                  child: Text(
                    food.foodName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (food.brandName.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      food.brandName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Serving information
            Row(
              children: [
                _buildInfoChip(
                  icon: Icons.scale,
                  label: '${food.servingSize} ${food.servingUnit}',
                ),
                const SizedBox(width: 8),
                _buildInfoChip(
                  icon: Icons.local_fire_department,
                  label: '${food.calories} kcal',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Nutrition facts
            const Text(
              'Nutrition Facts',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildNutritionRow('Protein', '${food.protein}g'),
            _buildNutritionRow('Carbs', '${food.carbs}g'),
            _buildNutritionRow('Fat', '${food.fat}g'),
            _buildNutritionRow('Fiber', '${food.fiber}g'),
            _buildNutritionRow('Sugar', '${food.sugar}g'),

            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Add to diary
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add to Diary'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    // TODO: Show more details
                  },
                  icon: const Icon(Icons.info_outline),
                  tooltip: 'More Details',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
