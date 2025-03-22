import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/explore_meals_controller.dart';

// Define the provider with the correct spelling
final exploreMealsControllerProvider =
    StateNotifierProvider<ExploreMealsController, ExploreMealsState>(
      (ref) => ExploreMealsController(),
    );
