import 'package:flutter/material.dart';
import '../../../models/meal.dart';

class MealWeightWidget extends StatelessWidget {
  final Meal meal;

  const MealWeightWidget({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weight Information',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text('Coming soon: Weight and portion details for ${meal.name}'),

          // Additional weight and portion information can be added here
        ],
      ),
    );
  }
}
