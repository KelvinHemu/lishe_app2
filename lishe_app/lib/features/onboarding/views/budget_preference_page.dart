import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/onboarding_controller.dart';

class BudgetPreferencePage extends ConsumerStatefulWidget {
  const BudgetPreferencePage({super.key});

  @override
  ConsumerState<BudgetPreferencePage> createState() =>
      _BudgetPreferencePageState();
}

class _BudgetPreferencePageState extends ConsumerState<BudgetPreferencePage> {
  // Budget options
  String? _selectedBudgetOption;
  final TextEditingController _customBudgetController = TextEditingController();
  bool _isCustomBudget = false;

  // Budget options definitions
  final Map<String, Map<String, dynamic>> _budgetOptions = {
    'low': {
      'label': 'Low Budget',
      'amount': '2,000',
      'description': 'Low-cost local meals like ugali, beans, vegetables',
      'icon': '🔹',
    },
    'medium': {
      'label': 'Medium Budget',
      'amount': '5,000',
      'description': 'Balanced meals with more variety',
      'icon': '🔸',
    },
    'high': {
      'label': 'High Budget',
      'amount': '10,000+',
      'description': 'More diverse foods including meat, dairy, etc.',
      'icon': '🔺',
    },
  };

  @override
  void dispose() {
    _customBudgetController.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _selectedBudgetOption != null ||
      (_isCustomBudget && _customBudgetController.text.isNotEmpty);

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
                  // Back button and Optional label
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
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "OPTIONAL",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Skip this optional step
                          context.go('/home');
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Title
                  Text(
                    "Food Budget Preference",
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
                    "How much can you spend on food daily?",
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

            // Budget options section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Budget options
                    ..._budgetOptions.entries.map((entry) {
                      final String key = entry.key;
                      final Map<String, dynamic> option = entry.value;

                      return _buildBudgetOption(
                        icon: option['icon'],
                        label: option['label'],
                        amount: option['amount'],
                        description: option['description'],
                        isSelected:
                            _selectedBudgetOption == key && !_isCustomBudget,
                        onTap: () {
                          setState(() {
                            _selectedBudgetOption = key;
                            _isCustomBudget = false;
                          });
                        },
                      );
                    }).toList(),

                    const SizedBox(height: 32),

                    // Custom budget option
                    Text(
                      "Or enter your budget:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _customBudgetController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              hintText: 'Amount in TZS',
                              prefixText: 'TZS ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                            ),
                            onChanged: (_) {
                              setState(() {
                                if (_customBudgetController.text.isNotEmpty) {
                                  _isCustomBudget = true;
                                }
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        DropdownButton<String>(
                          value: 'daily',
                          items: [
                            DropdownMenuItem(
                              value: 'daily',
                              child: Text('Daily'),
                            ),
                            DropdownMenuItem(
                              value: 'weekly',
                              child: Text('Weekly'),
                            ),
                          ],
                          onChanged: (value) {
                            // Can be implemented if needed
                          },
                          underline: Container(),
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                          dropdownColor: Colors.white,
                          elevation: 2,
                        ),
                      ],
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
                                  "☝️Your budget helps us suggest affordable meals",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "We'll recommend meals that match your budget while meeting your nutritional needs.",
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
                    ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
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

                            // Save budget preference in the onboarding state
                            final onboardingController =
                                ref.read(onboardingControllerProvider.notifier);

                            // Determine the budget amount
                            String budgetAmount;
                            if (_isCustomBudget) {
                              budgetAmount = _customBudgetController.text;
                            } else {
                              final option =
                                  _budgetOptions[_selectedBudgetOption]!;
                              budgetAmount = option['amount']
                                  .toString()
                                  .replaceAll(',', '')
                                  .replaceAll('+', '');
                            }

                            // Save the budget preference using the setBudget method
                            onboardingController.setBudget(
                              amount: budgetAmount,
                              frequency: 'daily', // Default to daily for now
                            );

                            // Navigate to the home page
                            context.go('/home');
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
                          _isValid ? 'Finish' : 'Select an option to continue',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_isValid) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.check_circle, size: 18),
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

  Widget _buildBudgetOption({
    required String icon,
    required String label,
    required String amount,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green.shade400 : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Budget icon and check indicator
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected ? Colors.green.shade100 : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                  if (isSelected)
                    Positioned(
                      right: 0,
                      bottom: 0,
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

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'TZS ${amount}/day',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 200.ms)
        .slideY(begin: 0.05, end: 0);
  }
}
