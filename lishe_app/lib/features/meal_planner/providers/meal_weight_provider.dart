import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/meal_weight_controller.dart';
import '../models/meal.dart';

final mealWeightControllerProvider =
    ChangeNotifierProvider.family<MealWeightController, Meal>(
      (ref, meal) => MealWeightController(meal: meal),
    );
