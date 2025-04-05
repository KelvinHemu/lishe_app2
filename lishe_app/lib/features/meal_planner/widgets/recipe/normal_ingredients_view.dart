import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../models/meal.dart';

class NormalIngredientsView extends StatelessWidget {
  final Meal meal;

  const NormalIngredientsView({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    final mainIngredients = meal.ingredients.take(4).toList();
    final extraIngredients = meal.ingredients.skip(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Recipe Info Row - Simplified design
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem(label: 'Time', value: meal.preparationTime),
              Container(height: 24, width: 1, color: Colors.grey.shade300),
              _buildInfoItem(label: 'Difficulty', value: meal.difficulty),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Main Ingredients Section
        _buildSectionHeader(title: 'Main Ingredients'),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: _buildIngredientGrid(mainIngredients),
        ),

        if (extraIngredients.isNotEmpty) ...[
          const SizedBox(height: 24),
          // Extra Ingredients Section
          _buildSectionHeader(title: 'Extra Ingredients'),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: _buildIngredientGrid(extraIngredients),
          ),
        ],

        const SizedBox(height: 24),

        // Tools Section
        _buildSectionHeader(title: 'Tools Needed'),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildToolChip('Cooking Pot'),
              _buildToolChip('Pan'),
              _buildToolChip('Knife'),
              _buildToolChip('Cutting Board'),
              _buildToolChip('Measuring Spoons'),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Recipe Instructions
        if (meal.recipe.isNotEmpty) ...[
          _buildSectionHeader(title: 'Directions'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: _buildNumberedInstructions(meal.recipe),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionHeader({required String title}) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 58, 58, 57),
      ),
    );
  }

  Widget _buildIngredientItem(String ingredient) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            PhosphorIcon(
              PhosphorIcons.carrot(),
              size: 18,
              color: Colors.green.shade700,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                ingredient,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolChip(String tool) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        tool,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildNumberedInstructions(String recipe) {
    if (recipe.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Text(
          'No instructions available for this recipe.',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    final steps =
        recipe.trim().split('. ').where((step) => step.isNotEmpty).toList();

    return Column(
      children:
          steps.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final step = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '$index',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      step,
                      style: const TextStyle(height: 1.5, fontSize: 15),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildIngredientGrid(List<String> ingredients) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        return _buildIngredientItem(ingredients[index]);
      },
    );
  }

  Widget _buildInfoItem({required String label, required String value}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
