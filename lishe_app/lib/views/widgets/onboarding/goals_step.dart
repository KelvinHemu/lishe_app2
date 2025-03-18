import 'package:flutter/material.dart';

class GoalsStep extends StatelessWidget {
  final String? selectedGoal;
  final TextEditingController targetWeightController;
  final String? selectedActivityLevel;
  final Function(String?) onGoalChanged;
  final Function(String?) onActivityLevelChanged;
  final List<String> goalOptions;
  final List<String> activityLevelOptions;
  final VoidCallback onNextPressed;

  const GoalsStep({
    super.key,
    this.selectedGoal,
    required this.targetWeightController,
    this.selectedActivityLevel,
    required this.onGoalChanged,
    required this.onActivityLevelChanged,
    required this.goalOptions,
    required this.activityLevelOptions,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What are your health goals?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'This helps us tailor your meal plans to your specific needs',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Goal dropdown
          DropdownButtonFormField<String>(
            value: selectedGoal,
            decoration: const InputDecoration(
              labelText: 'Primary Goal',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              prefixIcon: Icon(Icons.emoji_events),
            ),
            items:
                goalOptions.map((goal) {
                  return DropdownMenuItem<String>(
                    value: goal,
                    child: Text(goal),
                  );
                }).toList(),
            onChanged: onGoalChanged,
          ),
          const SizedBox(height: 16),

          // Target weight field
          TextField(
            controller: targetWeightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Target Weight (kg, optional)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              prefixIcon: Icon(Icons.fitness_center),
            ),
          ),
          const SizedBox(height: 16),

          // Activity level dropdown
          DropdownButtonFormField<String>(
            value: selectedActivityLevel,
            decoration: const InputDecoration(
              labelText: 'Activity Level',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              prefixIcon: Icon(Icons.directions_run),
            ),
            items:
                activityLevelOptions.map((level) {
                  return DropdownMenuItem<String>(
                    value: level,
                    child: Text(level),
                  );
                }).toList(),
            onChanged: onActivityLevelChanged,
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNextPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Endelea (Next)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
