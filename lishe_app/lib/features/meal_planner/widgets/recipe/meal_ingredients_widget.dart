import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../models/meal.dart';
import 'normal_ingredients_view.dart';
import 'ai_chef_view.dart';

class MealIngredientsWidget extends StatefulWidget {
  final Meal meal;

  const MealIngredientsWidget({super.key, required this.meal});

  @override
  State<MealIngredientsWidget> createState() => _MealIngredientsWidgetState();
}

class _MealIngredientsWidgetState extends State<MealIngredientsWidget> {
  bool _showAiChef = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toggle Buttons Row
          Row(
            children: [
              Expanded(
                child: _buildToggleButton(
                  title: 'Normal',
                  icon: PhosphorIcons.cookingPot(PhosphorIconsStyle.bold),
                  isSelected: !_showAiChef,
                  onTap: () => setState(() => _showAiChef = false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildToggleButton(
                  title: 'AI Chef',
                  icon: PhosphorIcons.robot(PhosphorIconsStyle.bold),
                  isSelected: _showAiChef,
                  onTap: () => setState(() => _showAiChef = true),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Content based on selected view
          _showAiChef
              ? AiChefView(meal: widget.meal)
              : NormalIngredientsView(meal: widget.meal),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green.shade700 : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PhosphorIcon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : Colors.grey.shade700,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
