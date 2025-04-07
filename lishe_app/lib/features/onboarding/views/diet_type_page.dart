import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/onboarding_controller.dart';

class DietTypePage extends ConsumerStatefulWidget {
  const DietTypePage({super.key});

  @override
  ConsumerState<DietTypePage> createState() => _DietTypePageState();
}

class _DietTypePageState extends ConsumerState<DietTypePage> {
  final List<String> _selectedDietTypes = [];
  
  // Diet type options with icons for better visualization
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
  
  bool get _isValid => _selectedDietTypes.isNotEmpty;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize with any existing diet type selections
    final onboardingState = ref.read(onboardingControllerProvider);
    if (onboardingState.dietTypes.isNotEmpty) {
      _selectedDietTypes.addAll(onboardingState.dietTypes);
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
                              "Step 5 of 7",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: 0.70,
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
                    "Your Diet Type",
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
                    "Select a diet type that best fits your eating habits",
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
            
            // Diet type selection section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Diet type selection cards
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: _dietTypeOptions.length,
                      itemBuilder: (context, index) {
                        final option = _dietTypeOptions[index];
                        final isSelected = _selectedDietTypes.contains(option['value']);
                        
                        return _buildDietTypeCard(
                          icon: option['icon'],
                          title: option['value'],
                          isSelected: isSelected,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() {
                              if (isSelected) {
                                _selectedDietTypes.remove(option['value']);
                              } else {
                                // If selecting "Everything", clear other selections
                                if (option['value'] == 'Everything (no restrictions)') {
                                  _selectedDietTypes.clear();
                                } 
                                // If selecting other options, remove "Everything" if it exists
                                else if (_selectedDietTypes.contains('Everything (no restrictions)')) {
                                  _selectedDietTypes.remove('Everything (no restrictions)');
                                }
                                
                                _selectedDietTypes.add(option['value']);
                              }
                            });
                          },
                        );
                      },
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
                                  "☝️Your diet type influences your meal plan",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "We'll tailor our recommendations to match your dietary preferences.",
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
                    .fadeIn(duration: 400.ms, delay: 400.ms),
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
                child: AnimatedOpacity(
                  opacity: _isValid ? 1.0 : 0.5,
                  duration: const Duration(milliseconds: 200),
                  child: ElevatedButton(
                    onPressed: _isValid 
                      ? () {
                          HapticFeedback.mediumImpact();
                          
                          // Save diet type in the onboarding state
                          final onboardingController = ref.read(onboardingControllerProvider.notifier);
                          
                          // Update just the diet types
                          onboardingController.setDietaryInfo(
                            dietTypes: _selectedDietTypes,
                          );
                          
                          // Navigate to the allergies page
                          context.pushNamed('allergiesStep');
                        }
                      : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      disabledForegroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isValid 
                              ? 'Continue'
                              : 'Select a diet type',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_isValid) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 18),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.green.shade400 : Colors.grey.shade200,
            width: 2,
          ),
          boxShadow: isSelected 
              ? [BoxShadow(
                  color: Colors.green.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )]
              : null,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    icon,
                    style: const TextStyle(fontSize: 40),
                  ),
                  const SizedBox(height: 12),
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
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1.0, 1.0));
  }
} 