import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../models/meal.dart';
import '../../../providers/meal_storage_provider.dart';

class MealStorageWidget extends ConsumerWidget {
  final Meal meal;

  const MealStorageWidget({super.key, required this.meal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get storage information from providers
    final category = ref.watch(mealCategoryProvider(meal.id));
    final difficulty = ref.watch(mealDifficultyProvider(meal.id));
    final storageInstructions = ref.watch(
      mealStorageInstructionsProvider(meal.id),
    );
    final preparationTip = ref.watch(mealPreparationTipProvider(meal.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            PhosphorIcon(
              PhosphorIcons.package(),
              size: 20,
              color: const Color.fromARGB(255, 58, 58, 57),
            ),
            const SizedBox(width: 4),
            const Text(
              'Storage & Preparation',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meal category info
              Row(
                children: [
                  Icon(Icons.category, color: Colors.amber.shade700),
                  const SizedBox(width: 8),
                  Text(
                    'Category: $category',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Difficulty level
              Row(
                children: [
                  Icon(Icons.timer, color: Colors.amber.shade700),
                  const SizedBox(width: 8),
                  Text(
                    'Difficulty: $difficulty',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Storage instructions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.kitchen, color: Colors.amber.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      storageInstructions,
                      style: const TextStyle(height: 1.4),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Preparation tip
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.tips_and_updates, color: Colors.amber.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      preparationTip,
                      style: const TextStyle(height: 1.4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
