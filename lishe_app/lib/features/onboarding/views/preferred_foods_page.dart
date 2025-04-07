import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/onboarding_controller.dart';

class PreferredFoodsPage extends ConsumerStatefulWidget {
  const PreferredFoodsPage({super.key});

  @override
  ConsumerState<PreferredFoodsPage> createState() => _PreferredFoodsPageState();
}

class _PreferredFoodsPageState extends ConsumerState<PreferredFoodsPage> {
  final List<String> _selectedFoods = [];
  
  // Food categories with icons
  final List<Map<String, dynamic>> _foodCategories = [
    {'value': 'Fruits', 'icon': '🍎', 'description': 'Apples, bananas, berries, etc.'},
    {'value': 'Vegetables', 'icon': '🥦', 'description': 'Broccoli, spinach, carrots, etc.'},
    {'value': 'Grains', 'icon': '🌾', 'description': 'Rice, quinoa, oats, etc.'},
    {'value': 'Protein', 'icon': '🥩', 'description': 'Meat, fish, tofu, beans, etc.'},
    {'value': 'Dairy', 'icon': '🧀', 'description': 'Cheese, yogurt, milk, etc.'},
    {'value': 'Herbs & Spices', 'icon': '🌿', 'description': 'Basil, thyme, pepper, etc.'},
    {'value': 'Nuts & Seeds', 'icon': '🥜', 'description': 'Almonds, chia seeds, etc.'},
    {'value': 'Seafood', 'icon': '🐟', 'description': 'Fish, shrimp, mussels, etc.'},
    {'value': 'Healthy Snacks', 'icon': '🥗', 'description': 'Granola, hummus, etc.'},
  ];
  
  @override
  void initState() {
    super.initState();
    
    // Initialize with any existing preferred food selections
    final onboardingState = ref.read(onboardingControllerProvider);
    if (onboardingState.preferredFoods.isNotEmpty) {
      _selectedFoods.addAll(onboardingState.preferredFoods);
    }
  }
  
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
                              "Step 7 of 7",
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
                    "Preferred Foods",
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
                    "Select foods you enjoy to help us suggest delicious recipes for you",
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
            
            // Allergies selection section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Instruction text
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Select at least 3 food categories you enjoy. This helps us personalize your meal recommendations.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 400.ms),
                    
                    const SizedBox(height: 24),
                    
                    // Selected foods count
                    Text(
                      "Selected: ${_selectedFoods.length}/9",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _selectedFoods.length >= 3 ? Colors.green.shade700 : Colors.grey.shade600,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Food category options
                    ...List.generate(_foodCategories.length, (index) {
                      final food = _foodCategories[index];
                      final isSelected = _selectedFoods.contains(food['value']);
                      
                      return _buildFoodOption(
                        icon: food['icon'],
                        title: food['value'],
                        description: food['description'],
                        isSelected: isSelected,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            if (isSelected) {
                              _selectedFoods.remove(food['value']);
                            } else {
                              _selectedFoods.add(food['value']);
                            }
                          });
                        },
                      );
                    }),
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
                  onPressed: _selectedFoods.length >= 3 ? () {
                    HapticFeedback.mediumImpact();
                    
                    // Save preferred foods in the onboarding state
                    final onboardingController = ref.read(onboardingControllerProvider.notifier);
                    
                    // Update just the preferred foods
                    onboardingController.setDietaryInfo(
                      preferredFoods: _selectedFoods,
                    );
                    
                    // Navigate to the dashboard or next step
                    context.pushNamed('onboardingComplete');
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.grey.shade500,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Complete Setup',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.check_circle_outline, size: 18),
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
  
  // Widget for food category option
  Widget _buildFoodOption({
    required String icon,
    required String title,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green.shade300 : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              icon,
              style: TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.green.shade700 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Checkbox(
              value: isSelected,
              onChanged: (_) => onTap(),
              activeColor: Colors.green.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 200.ms);
  }
} 