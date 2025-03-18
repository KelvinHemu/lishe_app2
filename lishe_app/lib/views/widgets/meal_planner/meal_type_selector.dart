import 'package:flutter/material.dart';

class MealTypeSelector extends StatelessWidget {
  final String currentMealType;

  const MealTypeSelector({super.key, required this.currentMealType});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildMealTypeLabel(
          context,
          "Breakfast",
          currentMealType == "breakfast",
        ),
        _buildMealTypeLabel(context, "Lunch", currentMealType == "lunch"),
        _buildMealTypeLabel(context, "Dinner", currentMealType == "dinner"),
      ],
    );
  }

  Widget _buildMealTypeLabel(
    BuildContext context,
    String label,
    bool isSelected,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.blue.shade700 : Colors.black54,
          ),
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 3,
            width: 100, // Increased width
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
    );
  }
}
