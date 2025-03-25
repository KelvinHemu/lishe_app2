import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lishe_app/features/meal_planner/controllers/meal_weight_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../models/meal.dart';
import '../../providers/meal_weight_provider.dart';

class MealWeightWidget extends ConsumerWidget {
  final Meal meal;

  const MealWeightWidget({super.key, required this.meal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(mealWeightControllerProvider(meal));

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Total Weight Header
              Row(
                children: [
                  const Icon(Icons.scale, color: Color.fromARGB(255, 6, 6, 6)),
                  const SizedBox(width: 8),
                  const Text(
                    'Total Weight',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${controller.totalWeight} g',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    _buildWeightRow(controller),
                    const SizedBox(height: 16),
                    _buildServesRow(controller),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeightRow(MealWeightController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(
            PhosphorIcons.barbell(PhosphorIconsStyle.bold),
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          const SizedBox(width: 8),
          const Text(
            'Weight',
            style: TextStyle(
              color: Color.fromARGB(255, 1, 1, 1),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildTextField(
              initialValue: controller.weight.toString(),
              onChanged: controller.updateWeight,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'grams',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServesRow(MealWeightController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(
            PhosphorIcons.hash(PhosphorIconsStyle.bold),
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          const SizedBox(width: 8),
          const Text(
            'Serves',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildTextField(
              initialValue: controller.serves.toString(),
              onChanged: controller.updateServes,
            ),
          ),
          const SizedBox(width: 16),
          _buildCounterButton(
            icon: Icons.remove,
            onTap: controller.decrementServes,
          ),
          const SizedBox(width: 8),
          _buildCounterButton(
            icon: Icons.add,
            onTap: controller.incrementServes,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String initialValue,
    required Function(String) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(120, 33, 33, 33),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: TextField(
        controller: TextEditingController(text: initialValue),
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Color(0xFF2C5282),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.blue),
      ),
    );
  }
}
