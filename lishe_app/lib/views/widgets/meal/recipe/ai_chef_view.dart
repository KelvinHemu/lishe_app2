import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../models/meal.dart';

class AiChefView extends StatelessWidget {
  final Meal meal;

  const AiChefView({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  PhosphorIcon(
                    PhosphorIcons.robot(PhosphorIconsStyle.bold),
                    size: 24,
                    color: Colors.green.shade700,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AI Chef Suggestions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Coming soon: Personalized cooking tips, ingredient substitutions, and nutrition insights powered by AI.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
