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
      _weightController.text.isNotEmpty && _heightController.text.isNotEmpty;

  double? _bmi;
  String _bmiMessage = "";
  String _bmiSecondaryMessage = "";
  Color _bmiMessageColor = Colors.green.shade900;
  Color _bmiContainerColor = Colors.green.shade50;
  Icon _bmiIcon =
      Icon(Icons.info_outline, color: Colors.green.shade700, size: 20);

  @override
  void initState() {
    super.initState();

    // We'll use onChanged handlers instead of listeners
  }

  void _calculateBMI() {
    if (_weightController.text.isNotEmpty &&
        _heightController.text.isNotEmpty) {
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
            _bmiMessage =
                "Your BMI is ${calculatedBMI.toStringAsFixed(1)} - Underweight";
            _bmiSecondaryMessage =
                "Focus on muscle toning and a balanced diet.";
            _bmiMessageColor = Colors.orange.shade700;
            _bmiContainerColor = Colors.orange.shade50;
            _bmiIcon = Icon(Icons.info_outline,
                color: Colors.orange.shade700, size: 20);
          } else if (calculatedBMI >= 18.5 && calculatedBMI < 25) {
            // Normal weight
            _bmiMessage =
                "Your BMI is ${calculatedBMI.toStringAsFixed(1)} - Normal";
            _bmiSecondaryMessage =
                "You're maintaining a healthy weight. Keep it up!";
            _bmiMessageColor = Colors.green.shade700;
            _bmiContainerColor = Colors.green.shade50;
            _bmiIcon = Icon(Icons.check_circle_outline,
                color: Colors.green.shade700, size: 20);
          } else {
            // Overweight
            _bmiMessage =
                "Your BMI is ${calculatedBMI.toStringAsFixed(1)} - Overweight";
            _bmiSecondaryMessage = "We'll help you reach a healthier weight.";
            _bmiMessageColor = Colors.blue.shade700;
            _bmiContainerColor = Colors.blue.shade50;
            _bmiIcon =
                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20);
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
              "Step 3 of 4",
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
                value: 0.60,
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
                  "Tell us about you",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
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

          // Form Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Weight Input
                  _buildInputField(
                    controller: _weightController,
                    label: "Weight (kg)",
                    hintText: "e.g. 70",
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {});
                      if (_isFormValid) _calculateBMI();
                    },
                  ),

                  const SizedBox(height: 24),

                  // Height Input
                  _buildInputField(
                    controller: _heightController,
                    label: "Height (cm)",
                    hintText: "e.g. 170",
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {});
                      if (_isFormValid) _calculateBMI();
                    },
                  ),

                  const SizedBox(height: 32),

                  // BMI Information
                  if (_bmi != null)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _bmiContainerColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _bmiIcon,
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _bmiMessage,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _bmiMessageColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _bmiSecondaryMessage,
                            style: TextStyle(
                              fontSize: 14,
                              color: _bmiMessageColor.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 300.ms).scale(
                          begin: const Offset(0.95, 0.95),
                          end: const Offset(1, 1),
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
              child: AnimatedOpacity(
                opacity: _isFormValid ? 1.0 : 0.5,
                duration: const Duration(milliseconds: 200),
                child: ElevatedButton(
                  onPressed: _isFormValid
                      ? () {
                          HapticFeedback.mediumImpact();

                          // Get the onboarding state
                          final onboardingController =
                              ref.read(onboardingControllerProvider.notifier);
                          final onboardingState =
                              ref.read(onboardingControllerProvider);

                          // Save the height and weight
                          onboardingController.setBasicInfo(
                            age: onboardingState.age ?? 25,
                            weight: double.parse(_weightController.text),
                            height: double.parse(_heightController.text),
                            activityLevel: onboardingState.activityLevel ?? '',
                          );

                          // Navigate to the next page
                          context.pushNamed('dietaryPreferences');
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
                        _isFormValid ? 'Continue' : 'Enter your details',
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
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required TextInputType keyboardType,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 16,
              ),
              border: InputBorder.none,
            ),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
