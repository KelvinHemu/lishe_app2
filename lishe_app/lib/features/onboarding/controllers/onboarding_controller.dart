import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingState {
  final TextEditingController heightController;
  final TextEditingController weightController;
  final int? birthYear;
  final String? selectedGender;
  final String? selectedMealFrequency;
  final List<String> selectedDietaryPreferences;
  final List<String> selectedGoals;
  final Map<String, dynamic> healthInfo;
  final int? age;
  final double? weight;
  final double? height;
  final String? activityLevel;
  final String? dietType;
  final List<String> allergies;
  final List<String> preferredFoods;
  final String? budget;
  final String? budgetFrequency;

  OnboardingState({
    required this.heightController,
    required this.weightController,
    this.birthYear,
    this.selectedGender,
    this.selectedMealFrequency,
    this.selectedDietaryPreferences = const [],
    this.selectedGoals = const [],
    this.healthInfo = const {},
    this.age,
    this.weight,
    this.height,
    this.activityLevel,
    this.dietType,
    this.allergies = const [],
    this.preferredFoods = const [],
    this.budget,
    this.budgetFrequency = 'daily',
  });

  OnboardingState copyWith({
    TextEditingController? heightController,
    TextEditingController? weightController,
    int? birthYear,
    String? selectedGender,
    String? selectedMealFrequency,
    List<String>? selectedDietaryPreferences,
    List<String>? selectedGoals,
    Map<String, dynamic>? healthInfo,
    int? age,
    double? weight,
    double? height,
    String? activityLevel,
    String? dietType,
    List<String>? allergies,
    List<String>? preferredFoods,
    String? budget,
    String? budgetFrequency,
  }) {
    return OnboardingState(
      heightController: heightController ?? this.heightController,
      weightController: weightController ?? this.weightController,
      birthYear: birthYear ?? this.birthYear,
      selectedGender: selectedGender ?? this.selectedGender,
      selectedMealFrequency: selectedMealFrequency ?? this.selectedMealFrequency,
      selectedDietaryPreferences: selectedDietaryPreferences ?? this.selectedDietaryPreferences,
      selectedGoals: selectedGoals ?? this.selectedGoals,
      healthInfo: healthInfo ?? this.healthInfo,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      activityLevel: activityLevel ?? this.activityLevel,
      dietType: dietType ?? this.dietType,
      allergies: allergies ?? this.allergies,
      preferredFoods: preferredFoods ?? this.preferredFoods,
      budget: budget ?? this.budget,
      budgetFrequency: budgetFrequency ?? this.budgetFrequency,
    );
  }
}

class OnboardingController extends StateNotifier<OnboardingState> {
  OnboardingController() : super(OnboardingState(
    heightController: TextEditingController(),
    weightController: TextEditingController(),
  ));

  void setBirthYear(int? year) {
    state = state.copyWith(birthYear: year);
  }

  void setGender(String? gender) {
    state = state.copyWith(selectedGender: gender);
  }

  void setMealFrequency(String? frequency) {
    state = state.copyWith(selectedMealFrequency: frequency);
  }

  void setDietaryPreferences(List<String> preferences) {
    state = state.copyWith(selectedDietaryPreferences: preferences);
  }

  void setGoals(List<String> goals) {
    state = state.copyWith(selectedGoals: goals);
  }

  void setHealthInfo(Map<String, dynamic> info) {
    state = state.copyWith(healthInfo: info);
  }
  
  void setBasicInfo({
    required int age,
    required double weight,
    required double height,
    required String activityLevel,
  }) {
    // Update the text controllers too
    state.heightController.text = height.toString();
    state.weightController.text = weight.toString();
    
    // Update the state
    state = state.copyWith(
      age: age,
      weight: weight,
      height: height,
      activityLevel: activityLevel,
    );
  }

  void setDietaryInfo({
    String? dietType,
    List<String>? allergies,
    List<String>? preferredFoods,
  }) {
    state = state.copyWith(
      dietType: dietType,
      allergies: allergies,
      preferredFoods: preferredFoods,
    );
  }

  void setBudget({
    required String amount,
    String frequency = 'daily',
  }) {
    state = state.copyWith(
      budget: amount,
      budgetFrequency: frequency,
    );
  }

  void resetState() {
    state.heightController.clear();
    state.weightController.clear();
    state = OnboardingState(
      heightController: TextEditingController(),
      weightController: TextEditingController(),
    );
  }

  @override
  void dispose() {
    state.heightController.dispose();
    state.weightController.dispose();
    super.dispose();
  }
}

final onboardingControllerProvider = StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
  return OnboardingController();
});

// Define constants for the onboarding process
final List<String> genderOptions = ['Male', 'Female', 'Non-binary', 'Prefer not to say'];
final List<String> mealFrequencyOptions = ['3 meals', '4 meals', '5 meals', '6+ meals']; 