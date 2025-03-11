import 'package:flutter/material.dart';

class NutritionSummaryCard extends StatelessWidget {
  final Map<String, double> nutritionSummary;

  const NutritionSummaryCard({
    Key? key,
    required this.nutritionSummary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NutritionItem(
                  label: 'Calories',
                  value: nutritionSummary['calories']?.toInt() ?? 0,
                  unit: 'kcal',
                  color: Colors.orange,
                ),
                _NutritionItem(
                  label: 'Protein',
                  value: nutritionSummary['proteins']?.toInt() ?? 0,
                  unit: 'g',
                  color: Colors.red,
                ),
                _NutritionItem(
                  label: 'Carbs',
                  value: nutritionSummary['carbs']?.toInt() ?? 0,
                  unit: 'g',
                  color: Colors.blue,
                ),
                _NutritionItem(
                  label: 'Fat',
                  value: nutritionSummary['fats']?.toInt() ?? 0,
                  unit: 'g',
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NutritionItem extends StatelessWidget {
  final String label;
  final int value;
  final String unit;
  final Color color;

  const _NutritionItem({
    Key? key,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Icon(
            Icons.circle,
            color: color,
            size: 24.0,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 4.0),
        Text(
          '$value$unit',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
} 