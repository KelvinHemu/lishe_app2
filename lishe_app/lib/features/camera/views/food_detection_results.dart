import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/food_item.dart';

class FoodDetectionResults extends ConsumerWidget {
  final List<FoodItem> foodItems;
  final VoidCallback onRetake;

  const FoodDetectionResults({
    super.key,
    required this.foodItems,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Detection Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: onRetake,
            tooltip: 'Take another photo',
          ),
        ],
      ),
      body: foodItems.isEmpty
          ? _buildEmptyState(context)
          : _buildFoodList(context),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.no_food,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'No food items detected',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try taking another photo with clearer visibility of the food',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetake,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Take Another Photo'),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: foodItems.length,
      itemBuilder: (context, index) {
        final foodItem = foodItems[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () => _showFoodDetails(context, foodItem),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Food icon or image placeholder
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.restaurant,
                          color: Colors.green,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              foodItem.foodName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            if (foodItem.brandName.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  foodItem.brandName,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 8),
                            Text(
                              'Serving: ${foodItem.servingSize} ${foodItem.servingUnit}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _nutritionItem(
                        'Calories',
                        '${foodItem.calories.toStringAsFixed(0)} kcal',
                        Colors.red,
                      ),
                      _nutritionItem(
                        'Protein',
                        '${foodItem.protein.toStringAsFixed(1)}g',
                        Colors.purple,
                      ),
                      _nutritionItem(
                        'Carbs',
                        '${foodItem.carbs.toStringAsFixed(1)}g',
                        Colors.blue,
                      ),
                      _nutritionItem(
                        'Fat',
                        '${foodItem.fat.toStringAsFixed(1)}g',
                        Colors.amber,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => _showFoodDetails(context, foodItem),
                      child: const Text('Full Details'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _nutritionItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  void _showFoodDetails(BuildContext context, FoodItem foodItem) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Food title section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.restaurant,
                          color: Colors.green,
                          size: 36,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              foodItem.foodName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            if (foodItem.brandName.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  foodItem.brandName,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 8),
                            Text(
                              'Serving: ${foodItem.servingSize} ${foodItem.servingUnit}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Calories section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Calories',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${foodItem.calories.toStringAsFixed(0)} kcal',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Macronutrients section
                  const Text(
                    'Macronutrients',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildNutritionRow(
                      'Protein', foodItem.protein, 'g', Colors.purple),
                  _buildNutritionRow(
                      'Carbohydrate', foodItem.carbs, 'g', Colors.blue),
                  _buildNutritionRow('Fat', foodItem.fat, 'g', Colors.amber),
                  _buildNutritionRow(
                      'Fiber', foodItem.fiber, 'g', Colors.green),
                  _buildNutritionRow('Sugar', foodItem.sugar, 'g', Colors.pink),

                  const SizedBox(height: 24),

                  // Minerals section
                  const Text(
                    'Minerals',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildNutritionRow(
                      'Sodium', foodItem.sodium, 'mg', Colors.blueGrey),
                  _buildNutritionRow(
                      'Potassium', foodItem.potassium, 'mg', Colors.orange),
                  _buildNutritionRow(
                      'Calcium', foodItem.calcium, 'mg', Colors.indigo),
                  _buildNutritionRow('Iron', foodItem.iron, 'mg', Colors.brown),

                  const SizedBox(height: 24),

                  // Fats section
                  const Text(
                    'Fats Breakdown',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildNutritionRow('Saturated Fat', foodItem.saturatedFat,
                      'g', Colors.amber.shade800),
                  _buildNutritionRow('Unsaturated Fat', foodItem.unsaturatedFat,
                      'g', Colors.amber.shade600),
                  _buildNutritionRow('Trans Fat', foodItem.transFat, 'g',
                      Colors.amber.shade900),
                  _buildNutritionRow('Cholesterol', foodItem.cholesterol, 'mg',
                      Colors.red.shade300),

                  const SizedBox(height: 24),

                  // Vitamins section
                  const Text(
                    'Vitamins',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildNutritionRow('Vitamin A', foodItem.vitaminA, 'IU',
                      Colors.orange.shade700),
                  _buildNutritionRow('Vitamin C', foodItem.vitaminC, 'mg',
                      Colors.yellow.shade700),

                  const SizedBox(height: 32),

                  // Add to diary button (placeholder for future integration)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add functionality to save this food item to user's diary
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Food added to diary'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Add to Food Diary',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNutritionRow(
      String label, double value, String unit, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          const Spacer(),
          Text(
            '${value.toStringAsFixed(1)} $unit',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
