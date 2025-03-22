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
      // Featured meal
      getFeaturedMealOfTheDay(),

      // Breakfast options
      Meal(
        id: 'breakfast-1',
        name: "Greek Yogurt with Berries",
        calories: 320,
        protein: 18.0,
        carbs: 40.0,
        fat: 8.0,
        imageUrl:
            "https://images.unsplash.com/photo-1551963831-b3b1ca40c98e?w=500&q=80",
        mealTypes: ['breakfast'],
        category: "Breakfast",
        difficulty: "Easy",
        ingredients: ['Greek yogurt', 'Mixed berries', 'Honey', 'Granola'],
        recipe: 'Add berries and granola to yogurt. Drizzle with honey.',
      ),

      Meal(
        id: 'breakfast-2',
        name: "Uji with karanga",
        calories: 280,
        protein: 12.0,
        carbs: 45.0,
        fat: 6.0,
        imageUrl:
            "https://mkulimambunifu.org/wp-content/uploads/2021/11/uji-wa-ulezi.jpg",
        mealTypes: ['breakfast'],
        category: "Breakfast",
        difficulty: "Easy",
        ingredients: ['Millet flour', 'Water', 'Ground peanuts', 'Sugar'],
        recipe:
            'Boil water. Add millet flour while stirring. Add ground peanuts and sugar to taste.',
      ),

      // Lunch options
      Meal(
        id: 'lunch-1',
        name: "Kuku na Wali",
        calories: 480,
        protein: 32.0,
        carbs: 55.0,
        fat: 12.0,
        imageUrl:
            "https://images.unsplash.com/photo-1569058242252-623df46b5025?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        mealTypes: ['lunch'],
        category: "Main Course",
        difficulty: "Medium",
        ingredients: ['Chicken', 'Rice', 'Tomatoes', 'Onions', 'Spices'],
        recipe:
            'Cook rice. Fry chicken with onions, tomatoes, and spices. Serve together.',
      ),

      Meal(
        id: 'lunch-2',
        name: "Kidney Bean Stew",
        calories: 390,
        protein: 22.0,
        carbs: 60.0,
        fat: 8.0,
        imageUrl:
            "https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=500&q=80",
        mealTypes: ['lunch'],
        category: "Soup",
        difficulty: "Easy",
        ingredients: [
          'Kidney beans',
          'Tomatoes',
          'Onions',
          'Carrots',
          'Spices',
        ],
        recipe:
            'Soak beans overnight. Cook until soft. Add vegetables and simmer until tender.',
      ),

      // Dinner options
      Meal(
        id: 'dinner-1',
        name: "Ugali na Sukuma Wiki",
        calories: 450,
        protein: 18.0,
        carbs: 65.0,
        fat: 10.0,
        imageUrl:
            "https://upload.wikimedia.org/wikipedia/commons/4/48/Ugali_%26_Sukuma_Wiki.jpg",
        mealTypes: ['dinner'],
        category: "Main Course",
        difficulty: "Medium",
        ingredients: ['Maize flour', 'Kale', 'Onions', 'Tomatoes', 'Oil'],
        recipe:
            'Boil water and add maize flour to make ugali. Fry kale with onions and tomatoes.',
      ),

      Meal(
        id: 'dinner-2',
        name: "Fish with Sweet Potatoes",
        calories: 410,
        protein: 30.0,
        carbs: 38.0,
        fat: 14.0,
        imageUrl:
            "https://images.unsplash.com/photo-1559847844-5315695dadae?w=500&q=80",
        mealTypes: ['dinner'],
        category: "Seafood",
        difficulty: "Medium",
        ingredients: [
          'Tilapia',
          'Sweet potatoes',
          'Spinach',
          'Garlic',
          'Lemon',
        ],
        recipe:
            'Bake fish with lemon and garlic. Roast sweet potatoes. Serve with spinach.',
      ),

      // Snacks
      Meal(
        id: 'snack-1',
        name: "Roasted Groundnuts",
        calories: 180,
        protein: 8.0,
        carbs: 6.0,
        fat: 14.0,
        imageUrl:
            "https://plus.unsplash.com/premium_photo-1674076592971-716676c4ba9c?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        mealTypes: ['snack'],
        category: "Snack",
        difficulty: "Easy",
        ingredients: ['Groundnuts', 'Salt'],
        recipe:
            'Roast groundnuts in a pan until golden brown. Add salt to taste.',
      ),

      // Vegetarian options
      Meal(
        id: 'veg-1',
        name: "Vegetable Curry",
        calories: 320,
        protein: 10.0,
        carbs: 45.0,
        fat: 12.0,
        imageUrl:
            "https://images.unsplash.com/photo-1530062845289-9109b2c9c868?w=500&q=80",
        mealTypes: ['dinner', 'lunch'],
        category: "Vegetarian",
        difficulty: "Medium",
        ingredients: [
          'Potatoes',
          'Carrots',
          'Peas',
          'Coconut milk',
          'Curry spices',
        ],
        recipe:
            'Sauté vegetables. Add coconut milk and curry spices. Simmer until cooked.',
      ),

      // High protein option
      Meal(
        id: 'protein-1',
        name: "Grilled Beef with Vegetables",
        calories: 520,
        protein: 45.0,
        carbs: 20.0,
        fat: 28.0,
        imageUrl:
            "https://images.unsplash.com/photo-1544025162-d76694265947?w=500&q=80",
        mealTypes: ['dinner'],
        category: "High Protein",
        difficulty: "Medium",
        ingredients: [
          'Beef steak',
          'Bell peppers',
          'Onions',
          'Zucchini',
          'Olive oil',
        ],
        recipe:
            'Grill beef to desired doneness. Sauté vegetables with olive oil and herbs.',
      ),

      // Low carb option
      Meal(
        id: 'lowcarb-1',
        name: "Chicken and Avocado Salad",
        calories: 350,
        protein: 28.0,
        carbs: 12.0,
        fat: 22.0,
        imageUrl:
            "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&q=80",
        mealTypes: ['lunch'],
        category: "Low Carb",
        difficulty: "Easy",
        ingredients: [
          'Chicken breast',
          'Avocado',
          'Lettuce',
          'Tomatoes',
          'Olive oil',
        ],
        recipe:
            'Grill chicken. Mix with chopped vegetables and sliced avocado. Dress with olive oil and lemon.',
      ),

      // Low calorie option
      Meal(
        id: 'lowcal-1',
        name: "Vegetable Soup",
        calories: 180,
        protein: 8.0,
        carbs: 22.0,
        fat: 6.0,
        imageUrl:
            "https://images.unsplash.com/photo-1643786661490-966f1877effa?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        mealTypes: ['lunch', 'dinner'],
        category: "Low Calorie",
        difficulty: "Easy",
        ingredients: [
          'Mixed vegetables',
          'Vegetable stock',
          'Herbs',
          'Garlic',
          'Onion',
        ],
        recipe:
            'Sauté onion and garlic. Add vegetables and stock. Simmer until vegetables are tender.',
      ),

      // Local food option
      Meal(
        id: 'local-1',
        name: "Pilau",
        calories: 460,
        protein: 20.0,
        carbs: 62.0,
        fat: 15.0,
        imageUrl:
            "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500&q=80",
        mealTypes: ['lunch', 'dinner'],
        category: "Local Foods",
        difficulty: "Challenging",
        ingredients: [
          'Rice',
          'Beef',
          'Pilau masala',
          'Onions',
          'Garlic',
          'Tomatoes',
        ],
        recipe:
            'Fry meat with spices. Add rice and water. Cook until rice is done.',
      ),
    ];
  }

  /// Get a random meal from the available meals
  Meal getRandomMeal() {
    final allMeals = getAllMockMeals();
    final random = DateTime.now().millisecondsSinceEpoch;
    return allMeals[random % allMeals.length];
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
