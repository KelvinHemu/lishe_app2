import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides storage information for meals based on their type
final mealStorageProvider = Provider.family<Map<String, dynamic>, String>((
  ref,
  mealId,
) {
  // Here we could fetch from a database or API based on mealId
  // For now, we'll return mock data based on the first character of the ID

  // Default storage info
  Map<String, dynamic> defaultStorage = {
    'category': 'Main Course',
    'difficulty': 'Medium',
    'storageInstructions':
        'Store in an airtight container in the refrigerator for up to 3 days. For best results, reheat thoroughly before serving.',
    'preparationTip':
        'For optimal nutritional benefits, consume within 24 hours of preparation.',
  };

  // Different categories based on ID
  final categories = [
    'Breakfast',
    'Main Course',
    'Side Dish',
    'Dessert',
    'Snack',
    'Soup',
    'Salad',
    'Drink',
  ];

  // Different difficulty levels
  final difficulties = ['Easy', 'Medium', 'Challenging', 'Advanced'];

  // Special storage instructions based on first character of ID
  if (mealId.isNotEmpty) {
    final firstChar = mealId[0].toLowerCase();
    final charCode = firstChar.codeUnitAt(0);

    // Category based on ID
    final categoryIndex = charCode % categories.length;
    defaultStorage['category'] = categories[categoryIndex];

    // Difficulty based on ID
    final difficultyIndex = (charCode ~/ 3) % difficulties.length;
    defaultStorage['difficulty'] = difficulties[difficultyIndex];

    // Custom storage instructions for some types of meals
    if (defaultStorage['category'] == 'Dessert') {
      defaultStorage['storageInstructions'] =
          'Store in an airtight container at room temperature for up to 2 days or refrigerate for up to 1 week.';
    } else if (defaultStorage['category'] == 'Salad') {
      defaultStorage['storageInstructions'] =
          'Keep refrigerated. For best freshness, store dressing separately and add just before serving.';
      defaultStorage['preparationTip'] =
          'Add avocado or other sensitive ingredients just before serving to prevent browning.';
    } else if (defaultStorage['category'] == 'Soup') {
      defaultStorage['storageInstructions'] =
          'Refrigerate for up to 4 days or freeze for up to 3 months. Reheat thoroughly before serving.';
    } else if (defaultStorage['category'] == 'Breakfast') {
      defaultStorage['preparationTip'] =
          'Prepare ingredients the night before for a quicker morning routine.';
    }
  }

  return defaultStorage;
});

/// Provider that returns a combined string of storage information
final mealStorageInstructionsProvider = Provider.family<String, String>((
  ref,
  mealId,
) {
  final storageInfo = ref.watch(mealStorageProvider(mealId));
  return storageInfo['storageInstructions'] as String;
});

/// Provider that returns the preparation tip
final mealPreparationTipProvider = Provider.family<String, String>((
  ref,
  mealId,
) {
  final storageInfo = ref.watch(mealStorageProvider(mealId));
  return storageInfo['preparationTip'] as String;
});

/// Provider that returns the meal category
final mealCategoryProvider = Provider.family<String, String>((ref, mealId) {
  final storageInfo = ref.watch(mealStorageProvider(mealId));
  return storageInfo['category'] as String;
});

/// Provider that returns the meal difficulty
final mealDifficultyProvider = Provider.family<String, String>((ref, mealId) {
  final storageInfo = ref.watch(mealStorageProvider(mealId));
  return storageInfo['difficulty'] as String;
});
