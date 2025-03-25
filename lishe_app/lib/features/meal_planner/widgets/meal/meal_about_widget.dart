import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../models/meal.dart';

class MealAboutWidget extends StatelessWidget {
  final Meal meal;

  const MealAboutWidget({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // About Section
          Row(
            children: [
              Icon(
                Icons.info,
                size: 18,
                color: const Color.fromARGB(255, 58, 58, 57),
              ),
              const SizedBox(width: 4),
              const Text(
                'About',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(20, 85, 84, 84),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              meal.description.isNotEmpty
                  ? meal.description
                  : 'A delicious and nutritious ${meal.name} that provides essential nutrients for your body. '
                      'This meal is carefully prepared with quality ingredients to ensure both taste and health benefits.',
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),

          const SizedBox(height: 24),

          // Nutrition Summary Section
          Row(
            children: [
              PhosphorIcon(
                PhosphorIcons.chartBar(),
                size: 20,
                color: const Color.fromARGB(255, 58, 58, 57),
              ),
              const SizedBox(width: 4),
              const Text(
                'Nutrition Summary',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(20, 85, 84, 84),
              borderRadius: BorderRadius.circular(10),
            ),
            child: _buildNutritionSummary(),
          ),

          const SizedBox(height: 24),

          // Storage Widget with Header Row
          Row(
            children: [
              PhosphorIcon(
                PhosphorIcons.hardDrive(),
                size: 20,
                color: const Color.fromARGB(255, 58, 58, 57),
              ),
              const SizedBox(width: 4),
              const Text(
                'Storage',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                width: 36,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF8A7A00).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.play_arrow, color: Colors.amber, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildStorageWidget(context),
        ],
      ),
    );
  }

  Widget _buildNutritionSummary() {
    return Column(
      children: [
        // Basic macronutrient info with visual bars
        _buildNutrientBar(
          label: 'Calories',
          value: meal.calories,
          unit: 'kcal',
          color: Colors.orange,
          maxValue: 800,
        ),
        const SizedBox(height: 8),
        _buildNutrientBar(
          label: 'Protein',
          value: meal.protein,
          unit: 'g',
          color: Colors.red,
          maxValue: 50,
        ),
        const SizedBox(height: 8),
        _buildNutrientBar(
          label: 'Carbs',
          value: meal.carbs,
          unit: 'g',
          color: Colors.blue,
          maxValue: 100,
        ),
        const SizedBox(height: 8),
        _buildNutrientBar(
          label: 'Fat',
          value: meal.fat,
          unit: 'g',
          color: Colors.green,
          maxValue: 40,
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildNutrientBar({
    required String label,
    required dynamic value,
    required String unit,
    required Color color,
    required double maxValue,
  }) {
    // Calculate the percentage, capped at 100%
    final double percentage = (value / maxValue).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(
              '$value $unit',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 8,
            width: double.infinity,
            color: Colors.grey.shade200,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(color: color),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStorageWidget(BuildContext context) {
    // Get storage information from meal model or use default for cheeseburger
    final String storageInfo =
        meal.storageInformation ??
        'A ${meal.name}, once it is cooked, can be safely stored in the refrigerator for 3-4 days, or frozen for 2-3 months; it\'s always best to wrap it well to retain its tasty flavour and prevent it from drying out.';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(13, 90, 86, 86),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(storageInfo, style: const TextStyle(fontSize: 15, height: 1.4)),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF3C3C3C).withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Table header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: const [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Type',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Fridge',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Freezer',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Shelf',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Raw row
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: const [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Raw',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'NA',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'NA',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'NA',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),

                // Cooked row
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: const [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Cooked',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '3-4 days',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '2-3 months',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'NA',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
