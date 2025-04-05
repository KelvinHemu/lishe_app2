import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../models/meal.dart';
import '../../controllers/meal_planner_controller.dart';
import '../../views/meal_detail_screen.dart';

class MealTypeSelector extends StatelessWidget {
  final String currentMealType;
  final MealPlannerController controller;
  final DateTime selectedDate;
  final Function(String) onMealTap;

  const MealTypeSelector({
    super.key,
    required this.currentMealType,
    required this.controller,
    required this.selectedDate,
    required this.onMealTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Today\'s Meal Plan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
        ),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildMealTypeCard(
                context,
                'breakfast',
                PhosphorIcons.coffee(),
                'Breakfast',
                controller.getBreakfastForDate(selectedDate),
              ),
              _buildDivider(),
              _buildMealTypeCard(
                context,
                'lunch',
                PhosphorIcons.forkKnife(),
                'Lunch',
                controller.getLunchForDate(selectedDate),
              ),
              _buildDivider(),
              _buildMealTypeCard(
                context,
                'dinner',
                PhosphorIcons.cookingPot(),
                'Dinner',
                controller.getDinnerForDate(selectedDate),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(color: Colors.grey.shade200, height: 1),
    );
  }

  Widget _buildMealTypeCard(
    BuildContext context,
    String mealType,
    IconData icon,
    String label,
    Meal? meal,
  ) {
    final bool isCurrentMealType = currentMealType == mealType;
    final bool hasMeal = meal != null;

    return InkWell(
      onTap: () => onMealTap(mealType),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color:
                    isCurrentMealType
                        ? Colors.green.shade100
                        : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: PhosphorIcon(
                icon,
                size: 24,
                color:
                    isCurrentMealType
                        ? Colors.green.shade800
                        : Colors.grey.shade700,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              isCurrentMealType
                                  ? Colors.green.shade800
                                  : Colors.black87,
                        ),
                      ),
                      if (isCurrentMealType) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 2.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade500,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Now',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hasMeal ? meal.name : 'Tap to select a meal',
                    style: TextStyle(
                      fontSize: 14,
                      color: hasMeal ? Colors.black87 : Colors.grey.shade600,
                      fontStyle: hasMeal ? FontStyle.normal : FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (hasMeal)
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MealDetailScreen(meal: meal),
                    ),
                  );
                },
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                tooltip: 'View meal details',
              )
            else
              IconButton(
                onPressed: () => onMealTap(mealType),
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                tooltip: 'Add a meal',
              ),
          ],
        ),
      ),
    );
  }
}
