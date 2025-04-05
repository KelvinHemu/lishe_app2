import 'package:flutter/material.dart';

class BasicInfoStep extends StatelessWidget {
  final TextEditingController heightController;
  final TextEditingController weightController;
  final int? birthYear;
  final String? selectedGender;
  final String? selectedMealFrequency;
  final VoidCallback showYearPicker;
  final Function(String?) onGenderChanged;
  final Function(String?) onMealFrequencyChanged;
  final List<String> genderOptions;
  final List<String> mealFrequencyOptions;
  final String? username;
  final VoidCallback onNextPressed;

  const BasicInfoStep({
    super.key,
    required this.heightController,
    required this.weightController,
    this.birthYear,
    this.selectedGender,
    this.selectedMealFrequency,
    required this.showYearPicker,
    required this.onGenderChanged,
    required this.onMealFrequencyChanged,
    required this.genderOptions,
    required this.mealFrequencyOptions,
    this.username,
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
            'Tell us about yourself',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            username != null
                ? 'Habari $username! Help us personalize your nutrition plan.'
                : 'This helps us provide personalized nutrition recommendations',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Height field
          TextField(
            controller: heightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Height (cm)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              prefixIcon: Icon(Icons.height),
            ),
          ),
          const SizedBox(height: 30),

          // Weight field
          TextField(
            controller: weightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Weight (kg)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              prefixIcon: Icon(Icons.monitor_weight_outlined),
            ),
          ),
          const SizedBox(height: 30),

          // Birth Year selector
          GestureDetector(
            onTap: showYearPicker,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      birthYear != null
                          ? 'Birth Year: $birthYear'
                          : 'Select Birth Year',
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            birthYear != null
                                ? Colors.black
                                : Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Gender dropdown
          DropdownButtonFormField<String>(
            value: selectedGender,
            decoration: const InputDecoration(
              labelText: 'Gender',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              prefixIcon: Icon(Icons.person),
            ),
            items:
                genderOptions.map((gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
            onChanged: onGenderChanged,
          ),
          const SizedBox(height: 30),

          // Meal frequency dropdown
          DropdownButtonFormField<String>(
            value: selectedMealFrequency,
            decoration: const InputDecoration(
              labelText: 'Preferred Meal Frequency',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              prefixIcon: Icon(Icons.access_time),
            ),
            items:
                mealFrequencyOptions.map((frequency) {
                  return DropdownMenuItem<String>(
                    value: frequency,
                    child: Text(frequency),
                  );
                }).toList(),
            onChanged: onMealFrequencyChanged,
          ),
          const SizedBox(height: 60),

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
