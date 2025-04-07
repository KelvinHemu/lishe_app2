import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/onboarding_controller.dart';

class BasicInfoPage extends ConsumerStatefulWidget {
  const BasicInfoPage({super.key});

  @override
  ConsumerState<BasicInfoPage> createState() => _BasicInfoPageState();
}

class _BasicInfoPageState extends ConsumerState<BasicInfoPage> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  
  bool get _isFormValid => 
      _weightController.text.isNotEmpty && 
      _heightController.text.isNotEmpty;
      
  double? _bmi;
  String _bmiMessage = "";
  String _bmiSecondaryMessage = "";
  Color _bmiMessageColor = Colors.green.shade900;
  Color _bmiContainerColor = Colors.green.shade50;
  Icon _bmiIcon = Icon(Icons.info_outline, color: Colors.green.shade700, size: 20);
  
  @override
  void initState() {
    super.initState();
    
    // We'll use onChanged handlers instead of listeners
  }

  void _calculateBMI() {
    if (_weightController.text.isNotEmpty && _heightController.text.isNotEmpty) {
      try {
        double weight = double.parse(_weightController.text);
        double heightInCm = double.parse(_heightController.text);
        double heightInMeters = heightInCm / 100;
        
        // BMI formula: weight (kg) / (height (m) * height (m))
        double calculatedBMI = weight / (heightInMeters * heightInMeters);
        
        setState(() {
          _bmi = calculatedBMI;
          
          // Update message based on BMI category
          if (calculatedBMI < 18.5) {
            // Underweight
            _bmiMessage = "☝️Your BMI is ${calculatedBMI.toStringAsFixed(2)}, which is considered underweight";
            _bmiSecondaryMessage = "Focus on muscle toning and a balanced diet. Stay positive and try to keep your daily calorie consumption in the recommended range.";
            _bmiMessageColor = Colors.orange.shade900;
            _bmiContainerColor = Colors.green.shade50;
            _bmiIcon = Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20);
          } else if (calculatedBMI >= 18.5 && calculatedBMI < 25) {
            // Normal weight
            _bmiMessage = "☝️Your BMI is ${calculatedBMI.toStringAsFixed(2)}, which is considered normal";
            _bmiSecondaryMessage = "You are doing a good job keeping your weight in the normal range. We will use your index to tailor a personal program to your needs.";
            _bmiMessageColor = Colors.green.shade900;
            _bmiContainerColor = Colors.green.shade50;
            _bmiIcon = Icon(Icons.info_outline, color: Colors.green.shade700, size: 20);
          } else {
            // Overweight
            _bmiMessage = "☝️Your BMI is ${calculatedBMI.toStringAsFixed(2)}, which is considered overweight";
            _bmiSecondaryMessage = "You should pay more attention to your weight. We will use your index to tailor your personal program for weight loss.";
            _bmiMessageColor = Colors.blue.shade900;
            _bmiContainerColor = Colors.green.shade50;
            _bmiIcon = Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20);
          }
        });
      } catch (e) {
        // Handle parsing errors
        print("Error calculating BMI: $e");
      }
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    
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
                              "Step 3 of 5",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: 0.60,
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
                    "Tell us about you",
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
                    "We'll use this to calculate your calorie needs",
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
            
            // Form Fields
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Weight Field
                    _buildLabeledField(
                      emoji: '⚖️',
                      label: 'Weight',
                      child: TextField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}$'))],
                        decoration: InputDecoration(
                          hintText: 'kg',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        onChanged: (_) {
                          setState(() {});
                          _calculateBMI();
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Height Field
                    _buildLabeledField(
                      emoji: '📏',
                      label: 'Height',
                      child: TextField(
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}$'))],
                        decoration: InputDecoration(
                          hintText: 'cm',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        onChanged: (_) {
                          setState(() {});
                          _calculateBMI();
                        },
                      ),
                    ),
                    
                    // Info message
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        key: ValueKey<String>(_bmiMessage),
                        margin: const EdgeInsets.only(top: 36),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _bmiContainerColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _bmiIcon,
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _bmi != null
                                        ? _bmiMessage
                                        : "Your height and weight help us determine your body composition and calorie requirements.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: _bmiMessageColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (_bmi != null) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      _bmiSecondaryMessage,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: _bmiMessageColor,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                  opacity: _isFormValid ? 1.0 : 0.5,
                  duration: const Duration(milliseconds: 200),
                  child: ElevatedButton(
                    onPressed: _isFormValid 
                      ? () {
                          HapticFeedback.mediumImpact();
                          
                          // Save height and weight
                          final onboardingController = ref.read(onboardingControllerProvider.notifier);
                          final onboardingState = ref.read(onboardingControllerProvider);
                          
                          // Update state with height and weight
                          onboardingController.setBasicInfo(
                            age: onboardingState.age ?? 0,
                            weight: double.parse(_weightController.text),
                            height: double.parse(_heightController.text),
                            activityLevel: onboardingState.activityLevel ?? '',
                          );
                          
                          // Navigate to the age page
                          context.pushNamed('ageStep');
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
                          _isFormValid 
                              ? 'Continue'
                              : 'Complete all fields to continue',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_isFormValid) ...[
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
  
  Widget _buildLabeledField({
    required String emoji,
    required String label,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(emoji: emoji, label: label),
        const SizedBox(height: 8),
        child,
      ],
    ).animate().fadeIn(
      duration: 400.ms,
      delay: 200.ms,
    );
  }
  
  Widget _buildSectionLabel({
    required String emoji,
    required String label,
  }) {
    return Row(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
} 