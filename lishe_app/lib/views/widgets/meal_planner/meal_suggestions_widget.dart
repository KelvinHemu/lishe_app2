import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../models/meal.dart';
import '../../../controllers/meal_planner_controller.dart';
import '../../screens/meal_detail_screen.dart';

class MealSuggestionsWidget extends StatefulWidget {
  final MealPlannerController controller;
  final DateTime selectedDate;

  const MealSuggestionsWidget({
    Key? key,
    required this.controller,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<MealSuggestionsWidget> createState() => _MealSuggestionsWidgetState();
}

class _MealSuggestionsWidgetState extends State<MealSuggestionsWidget> {
  final List<String> _mealTypes = ['breakfast', 'lunch', 'dinner'];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Suggested Meals',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
          const SizedBox(height: 12),

          // Toggle buttons for meal types
          Row(
            children: List.generate(
              _mealTypes.length,
              (index) => Expanded(
                child: _buildToggleButton(
                  label: _mealTypes[index].capitalize(),
                  isSelected: _selectedIndex == index,
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Meal suggestion card
          _buildMealSuggestionCard(_mealTypes[_selectedIndex]),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade100 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.green.shade500 : Colors.grey.shade300,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.green.shade800 : Colors.grey.shade700,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealSuggestionCard(String mealType) {
    // Get suggested meal based on meal type
    Meal? suggestedMeal = _getSuggestedMeal(mealType);

    if (suggestedMeal == null) {
      return _buildEmptySuggestion(mealType);
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealDetailScreen(meal: suggestedMeal),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            // Meal image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                suggestedMeal.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    ),
              ),
            ),

            // Meal details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestedMeal.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          size: 16,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${suggestedMeal.calories} kcal',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          suggestedMeal.preparationTime,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to view details',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade800,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySuggestion(String mealType) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PhosphorIcon(
              mealType == 'breakfast'
                  ? PhosphorIcons.coffee()
                  : mealType == 'lunch'
                  ? PhosphorIcons.forkKnife()
                  : PhosphorIcons.cookingPot(),
              size: 32,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              'No ${mealType.capitalize()} suggestion available',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // Add logic to explore meals or generate a suggestion
              },
              child: Text(
                'Explore ${mealType.capitalize()} Options',
                style: TextStyle(color: Colors.green.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Meal? _getSuggestedMeal(String mealType) {
    switch (mealType) {
      case 'breakfast':
        return widget.controller.getSuggestedBreakfast(widget.selectedDate);
      case 'lunch':
        return widget.controller.getSuggestedLunch(widget.selectedDate);
      case 'dinner':
        return widget.controller.getSuggestedDinner(widget.selectedDate);
      default:
        return null;
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
