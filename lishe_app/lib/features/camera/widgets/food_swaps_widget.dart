import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../models/food_detection_result.dart';

class FoodSwapsWidget extends StatelessWidget {
  final List<FoodItem> foodItems;
  final List<DetectedFood> detectedFoods;
  final Function(FoodItem) onFoodSelected;

  const FoodSwapsWidget({
    super.key,
    required this.foodItems,
    required this.detectedFoods,
    required this.onFoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: foodItems.length,
      itemBuilder: (context, index) {
        final foodItem = foodItems[index];
        final detectedFood = detectedFoods[index];
        return _buildFoodSwapRow(foodItem, detectedFood);
      },
    );
  }

  Widget _buildFoodSwapRow(FoodItem foodItem, DetectedFood detectedFood) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onFoodSelected(foodItem),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Circular food image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 2,
                    ),
                    image: DecorationImage(
                      image: NetworkImage(foodItem.foodImageUrl ?? ''),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {
                        // Handle image loading error
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Food name and type
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        foodItem.foodName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        foodItem.foodType,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // Confidence score
                _buildConfidenceScore(detectedFood.confidence),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfidenceScore(double confidence) {
    final percentage = (confidence * 100).round();
    final color = _getConfidenceColor(confidence);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.6) return Colors.orange;
    return Colors.red;
  }
}
