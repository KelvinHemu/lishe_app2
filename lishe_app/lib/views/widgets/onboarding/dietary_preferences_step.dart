import 'package:flutter/material.dart';

class DietaryPreferencesStep extends StatelessWidget {
  final String? selectedDietType;
  final List<String> selectedAllergies;
  final List<String> selectedLocalFoods;
  final Function(String?) onDietTypeChanged;
  final Function(String, bool) onAllergyToggled;
  final Function(String, bool) onLocalFoodToggled;
  final List<String> dietTypeOptions;
  final List<String> allergyOptions;
  final List<String> localFoodOptions;
  final VoidCallback onNextPressed;

  const DietaryPreferencesStep({
    super.key,
    this.selectedDietType,
    required this.selectedAllergies,
    required this.selectedLocalFoods,
    required this.onDietTypeChanged,
    required this.onAllergyToggled,
    required this.onLocalFoodToggled,
    required this.dietTypeOptions,
    required this.allergyOptions,
    required this.localFoodOptions,
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
            'Food Preferences',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tell us about your regular eating habits and preferences',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Diet type dropdown
          DropdownButtonFormField<String>(
            value: selectedDietType,
            decoration: const InputDecoration(
              labelText: 'Diet Type',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              prefixIcon: Icon(Icons.restaurant_menu),
            ),
            items:
                dietTypeOptions.map((diet) {
                  return DropdownMenuItem<String>(
                    value: diet,
                    child: Text(diet),
                  );
                }).toList(),
            onChanged: onDietTypeChanged,
          ),
          const SizedBox(height: 24),

          // Food allergies
          const Text(
            'Food Allergies (if any)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children:
                allergyOptions.map((allergy) {
                  final isSelected = selectedAllergies.contains(allergy);
                  return FilterChip(
                    label: Text(allergy),
                    selected: isSelected,
                    checkmarkColor: Colors.white,
                    selectedColor: Colors.green,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    onSelected:
                        (selected) => onAllergyToggled(allergy, selected),
                  );
                }).toList(),
          ),
          const SizedBox(height: 24),

          // Local food preferences
          const Text(
            'Which foods do you eat regularly?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children:
                localFoodOptions.map((food) {
                  final isSelected = selectedLocalFoods.contains(food);
                  return FilterChip(
                    label: Text(food),
                    selected: isSelected,
                    checkmarkColor: Colors.white,
                    selectedColor: Colors.green,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    onSelected:
                        (selected) => onLocalFoodToggled(food, selected),
                  );
                }).toList(),
          ),
          const SizedBox(height: 150),

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
                'Next',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
