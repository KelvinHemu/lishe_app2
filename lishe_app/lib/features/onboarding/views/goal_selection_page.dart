import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/onboarding_controller.dart';

class GoalSelectionPage extends ConsumerStatefulWidget {
  const GoalSelectionPage({super.key});

  @override
  ConsumerState<GoalSelectionPage> createState() => _GoalSelectionPageState();
}

class _GoalSelectionPageState extends ConsumerState<GoalSelectionPage> {
  String? _selectedGoal;

  // Goal data including icons, titles, and colors
  final List<Map<String, dynamic>> _goals = [
    {
      'icon': '✅',
      'title': 'Lose weight',
      'description': 'Healthy, sustainable weight loss plan',
      'emoji': '🏃‍♀️',
    },
    {
      'icon': '💪',
      'title': 'Gain muscle',
      'description': 'Build strength with optimal nutrition',
      'emoji': '🏋️‍♂️',
    },
    {
      'icon': '🥗',
      'title': 'Eat healthier',
      'description': 'Balanced nutrition for overall wellness',
      'emoji': '🥦',
    },
    {
      'icon': '❤️',
      'title': 'Manage health',
      'subtitle': 'e.g. diabetes',
      'description': 'Specialized diets for health conditions',
      'emoji': '⚕️',
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
              "Step 1 of 4",
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
                value: 0.25,
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
                  "What's your main goal?",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: 12),
                Text(
                  "We'll customize your experience based on this",
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

          // Goals section
          Expanded(
            child: ListView.builder(
              itemCount: _goals.length,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              itemBuilder: (context, index) {
                final goal = _goals[index];
                final isSelected = _selectedGoal == goal['title'];

                return _buildGoalCard(
                  emoji: goal['icon'],
                  emojiAlt: goal['emoji'],
                  title: goal['title'],
                  description: goal['description'],
                  subtitle: goal['subtitle'],
                  isSelected: isSelected,
                  index: index,
                );
              },
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
                opacity: _selectedGoal != null ? 1.0 : 0.5,
                duration: const Duration(milliseconds: 200),
                child: ElevatedButton(
                  onPressed: _selectedGoal != null
                      ? () {
                          HapticFeedback.mediumImpact();

                          // Save the selected goal to the onboarding state
                          ref
                              .read(onboardingControllerProvider.notifier)
                              .setGoals([_selectedGoal!]);

                          // Navigate to the next page in the onboarding flow
                          context.pushNamed('activityLevelStep');
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
                        _selectedGoal != null ? 'Continue' : 'Select a goal',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_selectedGoal != null) ...[
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

  Widget _buildGoalCard({
    required String emoji,
    required String emojiAlt,
    required String title,
    required String description,
    String? subtitle,
    required bool isSelected,
    required int index,
  }) {
    final Color selectedColor = const Color(0xFF4CAF50);
    final Color selectedLightColor = const Color(0xFFE8F5E9);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() {
            _selectedGoal = title;
          });
        },
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
              // Goal emoji
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

              // Goal text
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
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
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
