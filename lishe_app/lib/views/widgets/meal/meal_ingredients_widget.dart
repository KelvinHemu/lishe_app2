import 'package:flutter/material.dart';
import '../../../models/meal.dart';

class MealIngredientsWidget extends StatelessWidget {
  final Meal meal;

  const MealIngredientsWidget({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ingredients',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Replace this with actual ingredients list when available
          Text('Coming soon: List of ingredients for ${meal.name}'),

          // You can add a more sophisticated ingredients list layout here later
        ],
      ),
    );
  }
}
