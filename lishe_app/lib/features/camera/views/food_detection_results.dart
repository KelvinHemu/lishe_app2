import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/food_item.dart';
import '../widgets/food_nutrition_card.dart';

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
        title: Text(
          foodItems.isEmpty
              ? 'No Foods Detected'
              : 'Detected Foods (${foodItems.length})',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: onRetake,
            tooltip: 'Take another photo',
          ),
        ],
      ),
      body: SafeArea(
        child: foodItems.isEmpty
            ? _buildEmptyState(context)
            : _buildFoodList(context),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Try taking another photo with clearer visibility of the food',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetake,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take Another Photo'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoodList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: foodItems.length,
      itemBuilder: (context, index) {
        final foodItem = foodItems[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: FoodNutritionCard(foodItem: foodItem),
        );
      },
    );
  }
}
