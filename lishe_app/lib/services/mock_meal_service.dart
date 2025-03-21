import '../models/meal.dart';

/// Service that provides mock meal data for development and testing
class MockMealService {
  static final MockMealService _instance = MockMealService._internal();

  factory MockMealService() {
    return _instance;
  }

  MockMealService._internal();

  /// Get a mock featured meal of the day
  Meal getFeaturedMealOfTheDay() {
    return Meal(
      id: 'featured-1',
      name: "Ugali Samaki",
      calories: 450,
      protein: 35.0,
      carbs: 22.0,
      fat: 28.0,
      imageUrl:
          "https://images.unsplash.com/photo-1676300184021-96fa00e1a987?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      mealTypes: ['lunch', 'dinner'],
      ingredients: [
        'Salmon fillet',
        'Avocado',
        'Red onion',
        'Tomato',
        'Lime juice',
        'Cilantro',
      ],
      recipe:
          'Grill salmon until flaky. Mix avocado, diced onion, tomato, lime juice and cilantro for salsa. Top salmon with salsa before serving.',
      weight: 250, // Add default weight
      servingSize: 1, // Add default serving size
    );
  }

  /// Get a specific mock meal by type
  Meal getMockMealByType(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return Meal(
          id: 'breakfast-1',
          name: "Greek Yogurt with Fresh Berries",
          calories: 320,
          protein: 18.0,
          carbs: 40.0,
          fat: 8.0,
          imageUrl: "assets/images/greek_yogurt.jpg",
          mealTypes: ['breakfast'],
          ingredients: ['Greek yogurt', 'Mixed berries', 'Honey', 'Granola'],
          recipe: 'Add berries and granola to yogurt. Drizzle with honey.',
        );
      case 'lunch':
        return Meal(
          id: 'lunch-1',
          name: "Quinoa Salad with Chickpeas",
          calories: 380,
          protein: 15.0,
          carbs: 52.0,
          fat: 14.0,
          imageUrl: "assets/images/quinoa_salad.jpg",
          mealTypes: ['lunch'],
          ingredients: [
            'Quinoa',
            'Chickpeas',
            'Cucumber',
            'Cherry tomatoes',
            'Feta cheese',
            'Olive oil',
          ],
          recipe:
              'Mix cooked quinoa with all ingredients. Dress with olive oil and lemon juice.',
        );
      case 'dinner':
      default:
        return getFeaturedMealOfTheDay();
    }
  }

  /// Get all mock meals for development
  List<Meal> getAllMockMeals() {
    return [
      getFeaturedMealOfTheDay(),
      getMockMealByType('breakfast'),
      getMockMealByType('lunch'),
    ];
  }

  /// Get mock food images for the horizontal scroll
  List<String> getMockFoodImages() {
    return [
      'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
      'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445',
      'https://images.unsplash.com/photo-1565958011703-44f9829ba187',
      'https://images.unsplash.com/photo-1482049016688-2d3e1b311543',
      'https://images.unsplash.com/photo-1511690656952-34342bb7c2f2',
      'https://images.unsplash.com/photo-1467003909585-2f8a72700288',
    ].map((url) => '$url?w=400&q=80').toList();
  }
}
