import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/onboarding_controller.dart';

class DietaryPreferencesPage extends ConsumerStatefulWidget {
  const DietaryPreferencesPage({super.key});

  @override
  ConsumerState<DietaryPreferencesPage> createState() => _DietaryPreferencesPageState();
}

class _DietaryPreferencesPageState extends ConsumerState<DietaryPreferencesPage> {
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
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    offset: const Offset(0, 3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back button and progress indicator
                  Row(
                    children: [
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black87,
                            size: 18,
                          ),
                        ),
                        onPressed: () => context.pop(),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                      
                      const SizedBox(width: 16),
                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Step 5 of 5",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: 1.0,
                              backgroundColor: Colors.grey.shade200,
                              color: const Color(0xFF4CAF50),
                              borderRadius: BorderRadius.circular(2),
                              minHeight: 4,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 40), // To balance with the back button
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Title
                  Text(
                    "Food Preferences",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: 0.1, end: 0),
                  
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
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Diet type section
                    _buildSectionHeader(
                      icon: Icons.restaurant_menu,
                      iconColor: Colors.green.shade700,
                      backgroundColor: Colors.green.shade50,
                      title: "Diet type",
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Diet type selection cards
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: _dietTypeOptions.length,
                      itemBuilder: (context, index) {
                        final option = _dietTypeOptions[index];
                        final isSelected = _selectedDietType == option['value'];
                        
                        return _buildDietTypeCard(
                          icon: option['icon'],
                          title: option['value'],
                          isSelected: isSelected,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() {
                              _selectedDietType = option['value'];
                            });
                          },
                        );
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Food allergies section
                    _buildSectionHeader(
                      icon: Icons.warning_amber_rounded,
                      iconColor: Colors.orange.shade700, 
                      backgroundColor: Colors.orange.shade50,
                      title: "Food allergies (if any)",
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Allergies chips
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 12,
                        children: _allergyOptions.map((allergy) {
                          final isSelected = _selectedAllergies.contains(allergy['value']);
                          return _buildSelectionChip(
                            label: allergy['value'],
                            icon: allergy['icon'],
                            isSelected: isSelected,
                            onSelected: (selected) {
                              HapticFeedback.lightImpact();
                              setState(() {
                                if (selected) {
                                  _selectedAllergies.add(allergy['value']);
                                } else {
                                  _selectedAllergies.remove(allergy['value']);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Regular foods section
                    _buildSectionHeader(
                      icon: Icons.favorite,
                      iconColor: Colors.blue.shade700,
                      backgroundColor: Colors.blue.shade50,
                      title: "Which foods do you eat regularly?",
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Food preference chips
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 12,
                        children: _localFoodOptions.map((food) {
                          final isSelected = _selectedLocalFoods.contains(food['value']);
                          return _buildSelectionChip(
                            label: food['value'],
                            icon: food['icon'],
                            isSelected: isSelected,
                            onSelected: (selected) {
                              HapticFeedback.lightImpact();
                              setState(() {
                                if (selected) {
                                  _selectedLocalFoods.add(food['value']);
                                } else {
                                  _selectedLocalFoods.remove(food['value']);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Info message
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.green.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "☝️Your food preferences matter",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "This helps us suggest meals that align with your tastes and dietary needs.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green.shade900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 600.ms),
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
                    
                    // Save preferences in the onboarding state
                    final onboardingController = ref.read(onboardingControllerProvider.notifier);
                    
                    // Update the dietary preferences
                    onboardingController.setDietaryPreferences(
                      _selectedLocalFoods,
                    );
                    
                    // Navigate to the diet type page (first step of food preferences)
                    context.pushNamed('dietTypeStep');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
      ),
    );
  }
  
  // Widget for section headers with icon
  Widget _buildSectionHeader({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }
  
  // Widget for diet type selection card
  Widget _buildDietTypeCard({
    required String icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green.shade400 : Colors.grey.shade200,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    icon,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.green.shade700 : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
  }
  
  // Widget for selection chip with icon
  Widget _buildSelectionChip({
    required String label,
    required String icon,
    required bool isSelected,
    required Function(bool) onSelected,
  }) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      selected: isSelected,
      checkmarkColor: Colors.white,
      selectedColor: Colors.green.shade600,
      backgroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? Colors.transparent : Colors.grey.shade300,
          width: 1,
        ),
      ),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: onSelected,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
} 