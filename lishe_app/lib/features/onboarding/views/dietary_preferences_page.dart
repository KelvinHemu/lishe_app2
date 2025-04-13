import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/onboarding_controller.dart';

class DietaryPreferencesPage extends ConsumerStatefulWidget {
  const DietaryPreferencesPage({super.key});

  @override
  ConsumerState<DietaryPreferencesPage> createState() =>
      _DietaryPreferencesPageState();
}

class _DietaryPreferencesPageState
    extends ConsumerState<DietaryPreferencesPage> {
  String? _selectedDietType;
  final List<String> _selectedAllergies = [];
  final List<String> _selectedLocalFoods = [];

  // Options lists with icons for better visualization
  final List<Map<String, dynamic>> _dietTypeOptions = [
    {
      'value': 'Everything (no restrictions)',
      'icon': '🍽️',
    },
    {
      'value': 'Vegetarian',
      'icon': '🥗',
    },
    {
      'value': 'Vegan',
      'icon': '🌱',
    },
    {
      'value': 'Halal',
      'icon': '🥩',
    },
    {
      'value': 'Low Carb',
      'icon': '🥦',
    },
    {
      'value': 'High Protein',
      'icon': '💪',
    },
  ];

  final List<Map<String, dynamic>> _allergyOptions = [
    {'value': 'Nuts', 'icon': '🥜'},
    {'value': 'Eggs', 'icon': '🥚'},
    {'value': 'Dairy', 'icon': '🥛'},
    {'value': 'Seafood', 'icon': '🦐'},
    {'value': 'Wheat/Gluten', 'icon': '🌾'},
    {'value': 'Soy', 'icon': '🫘'},
  ];

  final List<Map<String, dynamic>> _localFoodOptions = [
    {'value': 'Ugali', 'icon': '🍚'},
    {'value': 'Rice', 'icon': '🍚'},
    {'value': 'Beans', 'icon': '🫘'},
    {'value': 'Fish', 'icon': '🐟'},
    {'value': 'Chicken', 'icon': '🍗'},
    {'value': 'Beef', 'icon': '🥩'},
    {'value': 'Spinach/Mchicha', 'icon': '🥬'},
    {'value': 'Cassava', 'icon': '🥔'},
    {'value': 'Sweet Potatoes', 'icon': '🍠'},
    {'value': 'Bananas/Plantains', 'icon': '🍌'},
    {'value': 'Coconut', 'icon': '🥥'},
  ];

  bool get _isValid => true; // Always valid since all selections are optional

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const primaryColor = Color(0xFF4CAF50);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200, width: 1),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black87,
              size: 18,
            ),
          ),
          onPressed: () => context.pop(),
        ),
        title: Column(
          children: [
            Text(
              "Step 4 of 4",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 1.0,
                backgroundColor: Colors.grey.shade200,
                color: primaryColor,
                minHeight: 4,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Food Preferences",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: 12),
                Text(
                  "Tell us about your eating habits to personalize your meal plan",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 100.ms)
                    .slideY(begin: 0.1, end: 0),
              ],
            ),
          ),

          // Preferences input section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Diet type section
                  _buildSectionTitle("Diet type"),
                  const SizedBox(height: 16),

                  // Diet type options
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _dietTypeOptions.map((option) {
                      final bool isSelected =
                          _selectedDietType == option['value'];
                      return _buildSelectableChip(
                        icon: option['icon'],
                        label: option['value'],
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedDietType = null;
                            } else {
                              _selectedDietType = option['value'];
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Allergies section
                  _buildSectionTitle("Any allergies?"),
                  Text(
                    "Select all that apply",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Allergy options
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _allergyOptions.map((option) {
                      final bool isSelected =
                          _selectedAllergies.contains(option['value']);
                      return _buildSelectableChip(
                        icon: option['icon'],
                        label: option['value'],
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedAllergies.remove(option['value']);
                            } else {
                              _selectedAllergies.add(option['value']);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Local foods section
                  _buildSectionTitle("Favorite local foods"),
                  Text(
                    "Select foods you enjoy",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Local food options
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _localFoodOptions.map((option) {
                      final bool isSelected =
                          _selectedLocalFoods.contains(option['value']);
                      return _buildSelectableChip(
                        icon: option['icon'],
                        label: option['value'],
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedLocalFoods.remove(option['value']);
                            } else {
                              _selectedLocalFoods.add(option['value']);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // Continue Button
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -3),
                  blurRadius: 20,
                ),
              ],
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade100,
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();

                  // Save dietary preferences to the onboarding state
                  final onboardingController =
                      ref.read(onboardingControllerProvider.notifier);
                  onboardingController.setDietaryInfo(
                    dietType: _selectedDietType,
                    allergies: _selectedAllergies,
                    preferredFoods: _selectedLocalFoods,
                  );

                  // Navigate to the budget preference page or complete onboarding
                  context.pushNamed('budgetPreferenceStep');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSelectableChip({
    required String icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final Color selectedColor = const Color(0xFF4CAF50);
    final Color selectedLightColor = const Color(0xFFE8F5E9);

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      borderRadius: BorderRadius.circular(50),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? selectedLightColor : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isSelected ? selectedColor : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? selectedColor : Colors.black87,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.check_circle,
                size: 16,
                color: selectedColor,
              ),
            ],
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
