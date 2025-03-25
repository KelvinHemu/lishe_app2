import 'package:flutter/material.dart';

class HealthInfoStep extends StatelessWidget {
  final List<String> selectedHealthConditions;
  final Function(String, bool) onHealthConditionToggled;
  final List<String> healthConditionOptions;
  final VoidCallback onCompletePressed;
  final bool isLoading;

  const HealthInfoStep({
    super.key,
    required this.selectedHealthConditions,
    required this.onHealthConditionToggled,
    required this.healthConditionOptions,
    required this.onCompletePressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Health Information',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Do you have any health conditions we should consider?',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Health conditions
          const Text(
            'Health Conditions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children:
                healthConditionOptions.map((condition) {
                  final isSelected = selectedHealthConditions.contains(
                    condition,
                  );
                  return FilterChip(
                    label: Text(condition),
                    selected: isSelected,
                    checkmarkColor: Colors.white,
                    selectedColor: Colors.green,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    onSelected:
                        (selected) =>
                            onHealthConditionToggled(condition, selected),
                  );
                }).toList(),
          ),
          const SizedBox(height: 32),

          const Text(
            'Your nutrition recommendations will be adapted for your specific needs.',
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 150),

          SizedBox(
            width: double.infinity,
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                      onPressed: onCompletePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Kamilisha (Complete)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
