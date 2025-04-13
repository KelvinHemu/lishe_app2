import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/onboarding_controller.dart';

class ActivityLevelPage extends ConsumerStatefulWidget {
  const ActivityLevelPage({super.key});

  @override
  ConsumerState<ActivityLevelPage> createState() => _ActivityLevelPageState();
}

class _ActivityLevelPageState extends ConsumerState<ActivityLevelPage> {
  String? _activityLevel;

  final List<Map<String, dynamic>> _activityLevels = [
    {
      'icon': '🛋️',
      'title': 'Sedentary',
      'description': 'Little or no exercise',
    },
    {
      'icon': '🚶',
      'title': 'Lightly Active',
      'description': 'Light exercise 1-3 days/week',
    },
    {
      'icon': '🏃',
      'title': 'Moderately Active',
      'description': 'Moderate exercise 3-5 days/week',
    },
    {
      'icon': '🚴‍♀️',
      'title': 'Very Active',
      'description': 'Hard exercise 6-7 days/week',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
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
              "Step 2 of 4",
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
                value: 0.50,
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
                  "How active are you?",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: 12),
                Text(
                  "Choose your activity level to help us calculate your daily calorie needs",
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

          // Activity Level Options
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Activity Level Options
                  ...List.generate(_activityLevels.length, (index) {
                    final activity = _activityLevels[index];
                    final isSelected = _activityLevel == activity['title'];

                    return _buildActivityLevelOption(
                      emoji: activity['icon'],
                      title: activity['title'],
                      description: activity['description'],
                      isSelected: isSelected,
                      index: index,
                      onTap: () {
                        setState(() {
                          _activityLevel = activity['title'];
                        });

                        // Add haptic feedback
                        HapticFeedback.selectionClick();
                      },
                    );
                  }),
                ],
              ),
            ),
          ),

          // Continue Button (fixed at bottom)
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
                opacity: _activityLevel != null ? 1.0 : 0.5,
                duration: const Duration(milliseconds: 200),
                child: ElevatedButton(
                  onPressed: _activityLevel != null
                      ? () {
                          HapticFeedback.mediumImpact();

                          // Update activity level in the onboarding state
                          final onboardingController =
                              ref.read(onboardingControllerProvider.notifier);
                          final onboardingState =
                              ref.read(onboardingControllerProvider);

                          // Ensure _activityLevel is not null (defensive)
                          final activityLevel = _activityLevel;
                          if (activityLevel == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please select an activity level'),
                              ),
                            );
                            return;
                          }

                          // Re-save basic info with the selected activity level
                          onboardingController.setBasicInfo(
                            age: onboardingState.age ?? 0,
                            weight: onboardingState.weight ?? 0,
                            height: onboardingState.height ?? 0,
                            activityLevel: activityLevel,
                          );

                          // Navigate to the next page in the onboarding flow
                          context.pushNamed('basicInfoStep');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _activityLevel != null
                            ? 'Continue'
                            : 'Select your activity level',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_activityLevel != null) ...[
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
    );
  }

  Widget _buildActivityLevelOption({
    required String emoji,
    required String title,
    required String description,
    required bool isSelected,
    required int index,
    required VoidCallback onTap,
  }) {
    final Color selectedColor = const Color(0xFF4CAF50);
    final Color selectedLightColor = const Color(0xFFE8F5E9);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? selectedLightColor : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? selectedColor : Colors.grey.shade200,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: selectedColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              // Activity emoji
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? selectedColor.withOpacity(0.15)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? selectedColor : Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),

              const SizedBox(width: 16),

              // Activity text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? selectedColor : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected
                            ? selectedColor.withOpacity(0.7)
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Selection indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? selectedColor : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? selectedColor : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: 300.ms,
          delay: Duration(milliseconds: 100 + (index * 100)),
        )
        .slideY(
          begin: 0.1,
          end: 0,
          duration: 300.ms,
          delay: Duration(milliseconds: 100 + (index * 100)),
          curve: Curves.easeOutQuad,
        );
  }
}
