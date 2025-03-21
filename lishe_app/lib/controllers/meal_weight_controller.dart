import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealWeightController extends ChangeNotifier {
  final Meal meal;
  int _weight;
  int _serves;

  MealWeightController({required this.meal})
    : _weight = meal.weight ?? 250,
      _serves = meal.servingSize ?? 1;

  int get weight => _weight;
  int get serves => _serves;
  int get totalWeight => _weight * _serves;

  void updateWeight(String value) {
    if (value.isNotEmpty) {
      _weight = int.tryParse(value) ?? _weight;
      notifyListeners();
    }
  }

  void updateServes(String value) {
    if (value.isNotEmpty) {
      _serves = int.tryParse(value) ?? _serves;
      notifyListeners();
    }
  }

  void incrementServes() {
    _serves++;
    notifyListeners();
  }

  void decrementServes() {
    if (_serves > 1) {
      _serves--;
      notifyListeners();
    }
  }
}

class MealWeightWidget extends StatelessWidget {
  final MealWeightController controller;

  MealWeightWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${controller.totalWeight} g',
          style: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
