import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/user_profile_model.dart';
import '../../onboarding/views/basic_info_step.dart';
import 'goals_step.dart';
import '../../onboarding/views/dietary_preferences_step.dart';
import '../../onboarding/views/health_info_step.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({
    super.key,
    required userId,
    required username,
    required currentStep,
  });

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  int _currentStep = 0;
  bool _isLoading = false;

  // Controllers
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _targetWeightController = TextEditingController();

  // State variables
  int? _birthYear;
  String? _selectedGender;
  String? _selectedMealFrequency;

  // Health goals
  String? _selectedGoal;
  String? _selectedActivityLevel;

  // Dietary preferences
  String? _selectedDietType;
  final List<String> _selectedAllergies = [];
  final List<String> _selectedLocalFoods = [];

  // Health considerations
  final List<String> _selectedHealthConditions = [];

  // Lists for selection options (Tanzanian-focused)
  final List<String> _genderOptions = ['Male', 'Female', 'Prefer not to say'];
  final List<String> _goalOptions = [
    'Lose Weight',
    'Maintain Weight',
    'Gain Weight',
    'Build Muscle',
    'Improve Overall Health',
    'Manage Blood Sugar',
  ];
  final List<String> _activityLevelOptions = [
    'Sedentary (little or no exercise)',
    'Lightly Active (light exercise/sports 1-3 days/week)',
    'Moderately Active (moderate exercise/sports 3-5 days/week)',
    'Very Active (hard exercise/sports 6-7 days a week)',
    'Extra Active (very hard exercise, physical job or training twice a day)',
  ];
  final List<String> _dietTypeOptions = [
    'Everything (no restrictions)',
    'Vegetarian',
    'Vegan',
    'Halal',
    'Low Carb',
    'High Protein',
  ];
  final List<String> _allergyOptions = [
    'Nuts',
    'Eggs',
    'Dairy',
    'Seafood',
    'Wheat/Gluten',
    'Soy',
  ];
  final List<String> _localFoodOptions = [
    'Ugali',
    'Rice',
    'Beans',
    'Fish',
    'Chicken',
    'Beef',
    'Spinach/Mchicha',
    'Cassava',
    'Sweet Potatoes',
    'Bananas/Plantains',
    'Coconut',
  ];
  final List<String> _healthConditionOptions = [
    'Diabetes',
    'High Blood Pressure',
    'Heart Disease',
    'Digestive Issues',
    'None',
  ];
  final List<String> _mealFrequencyOptions = [
    '3 meals per day',
    '3 meals + snacks',
    '5-6 smaller meals',
    'Intermittent Fasting',
  ];

  // User data model
  final Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    // Pre-populate with any existing user data if available
    // Could fetch from a user service or local storage
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  Future<void> _nextStep() async {
    if (_currentStep < 3) {
      _saveCurrentStepData();
      setState(() {
        _currentStep += 1;
      });
    } else {
      await _completeSetup();
    }
  }

  void _saveCurrentStepData() {
    switch (_currentStep) {
      case 0:
        // Save basic info
        _userData['height'] =
            _heightController.text.isNotEmpty
                ? double.tryParse(_heightController.text)
                : null;
        _userData['weight'] =
            _weightController.text.isNotEmpty
                ? double.tryParse(_weightController.text)
                : null;
        _userData['birthYear'] = _birthYear;
        _userData['gender'] = _selectedGender;
        _userData['mealFrequency'] = _selectedMealFrequency;

        // Calculate age if birth year is provided
        if (_birthYear != null) {
          _userData['age'] = DateTime.now().year - _birthYear!;
        }
        break;

      case 1:
        // Save goals
        _userData['goal'] = _selectedGoal;
        _userData['targetWeight'] =
            _targetWeightController.text.isNotEmpty
                ? double.tryParse(_targetWeightController.text)
                : null;
        _userData['activityLevel'] = _selectedActivityLevel;
        break;

      case 2:
        // Save dietary preferences
        _userData['dietType'] = _selectedDietType;
        _userData['allergies'] = _selectedAllergies;
        _userData['preferredLocalFoods'] = _selectedLocalFoods;
        break;

      case 3:
        // Save health info
        _userData['healthConditions'] = _selectedHealthConditions;
        break;
    }
  }

  Future<void> _completeSetup() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _saveCurrentStepData();

      // Create a user profile object from collected data
      // ignore: unused_local_variable
      final userProfile = UserProfile.fromJson(_userData);

      // Here you would typically:
      // 1. Save to local storage
      // 2. Upload to your backend API
      // 3. Update app state via a provider or bloc

      // For now, we'll just simulate a delay and navigate
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving profile: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _skipSetup() {
    context.go('/home');
  }

  void _showYearPicker() {
    final int currentYear = DateTime.now().year;
    final int startYear = currentYear - 100;
    final int initialYear = _birthYear ?? (currentYear - 25);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Select Birth Year',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: YearPicker(
                  firstDate: DateTime(startYear),
                  lastDate: DateTime(currentYear),
                  selectedDate: DateTime(initialYear),
                  onChanged: (DateTime dateTime) {
                    setState(() {
                      _birthYear = dateTime.year;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _getStepTitle(_currentStep),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading:
            _currentStep > 0
                ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      _currentStep--;
                    });
                  },
                )
                : null,
        actions: [
          TextButton(
            onPressed: _skipSetup,
            child: const Text('Skip', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentStep + 1) / 4,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          ),

          // Current step content
          Expanded(child: _buildCurrentStep()),
        ],
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Basic Info';
      case 1:
        return 'Your Goals';
      case 2:
        return 'Food Preferences';
      case 3:
        return 'Health Info';
      default:
        return '';
    }
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return BasicInfoStep(
          heightController: _heightController,
          weightController: _weightController,
          birthYear: _birthYear,
          selectedGender: _selectedGender,
          selectedMealFrequency: _selectedMealFrequency,
          showYearPicker: _showYearPicker,
          onGenderChanged: (value) => setState(() => _selectedGender = value),
          onMealFrequencyChanged:
              (value) => setState(() => _selectedMealFrequency = value),
          genderOptions: _genderOptions,
          mealFrequencyOptions: _mealFrequencyOptions,
          onNextPressed: _nextStep,
        );
      case 1:
        return GoalsStep(
          selectedGoal: _selectedGoal,
          targetWeightController: _targetWeightController,
          selectedActivityLevel: _selectedActivityLevel,
          onGoalChanged: (value) => setState(() => _selectedGoal = value),
          onActivityLevelChanged:
              (value) => setState(() => _selectedActivityLevel = value),
          goalOptions: _goalOptions,
          activityLevelOptions: _activityLevelOptions,
          onNextPressed: _nextStep,
        );
      case 2:
        return DietaryPreferencesStep(
          selectedDietType: _selectedDietType,
          selectedAllergies: _selectedAllergies,
          selectedLocalFoods: _selectedLocalFoods,
          onDietTypeChanged:
              (value) => setState(() => _selectedDietType = value),
          onAllergyToggled: (allergy, selected) {
            setState(() {
              if (selected) {
                _selectedAllergies.add(allergy);
              } else {
                _selectedAllergies.remove(allergy);
              }
            });
          },
          onLocalFoodToggled: (food, selected) {
            setState(() {
              if (selected) {
                _selectedLocalFoods.add(food);
              } else {
                _selectedLocalFoods.remove(food);
              }
            });
          },
          dietTypeOptions: _dietTypeOptions,
          allergyOptions: _allergyOptions,
          localFoodOptions: _localFoodOptions,
          onNextPressed: _nextStep,
        );
      case 3:
        return HealthInfoStep(
          selectedHealthConditions: _selectedHealthConditions,
          onHealthConditionToggled: (condition, selected) {
            setState(() {
              if (selected) {
                _selectedHealthConditions.add(condition);
              } else {
                _selectedHealthConditions.remove(condition);
              }
            });
          },
          healthConditionOptions: _healthConditionOptions,
          onCompletePressed: _completeSetup,
          isLoading: _isLoading,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
