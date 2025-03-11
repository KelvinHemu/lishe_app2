import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/food_item.dart';

class FoodDatabaseInitializer {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initializeFoodDatabase() async {
    final batch = _firestore.batch();
    final foodItemsCollection = _firestore.collection('food_items');

    // Common Tanzanian and East African foods
    final List<FoodItem> commonFoods = [
      FoodItem(
        id: 'ugali-1',
        name: 'Ugali',
        calories: 120,
        proteins: 2.5,
        carbs: 25,
        fats: 0.5,
        servingSize: 100,
        servingUnit: 'g',
      ),
      FoodItem(
        id: 'rice-1',
        name: 'Rice (Cooked)',
        calories: 130,
        proteins: 2.7,
        carbs: 28,
        fats: 0.3,
        servingSize: 100,
        servingUnit: 'g',
      ),
      FoodItem(
        id: 'beans-1',
        name: 'Beans (Cooked)',
        calories: 132,
        proteins: 8.9,
        carbs: 24,
        fats: 0.5,
        servingSize: 100,
        servingUnit: 'g',
      ),
      FoodItem(
        id: 'chapati-1',
        name: 'Chapati',
        calories: 120,
        proteins: 3,
        carbs: 20,
        fats: 3.5,
        servingSize: 1,
        servingUnit: 'piece',
      ),
      FoodItem(
        id: 'sukuma-wiki-1',
        name: 'Sukuma Wiki (Cooked)',
        calories: 30,
        proteins: 2.3,
        carbs: 5.2,
        fats: 0.4,
        servingSize: 100,
        servingUnit: 'g',
      ),
      FoodItem(
        id: 'beef-1',
        name: 'Beef (Cooked)',
        calories: 250,
        proteins: 26,
        carbs: 0,
        fats: 15,
        servingSize: 100,
        servingUnit: 'g',
      ),
      FoodItem(
        id: 'chicken-1',
        name: 'Chicken (Cooked)',
        calories: 165,
        proteins: 31,
        carbs: 0,
        fats: 3.6,
        servingSize: 100,
        servingUnit: 'g',
      ),
      FoodItem(
        id: 'fish-1',
        name: 'Fish (Tilapia, Cooked)',
        calories: 128,
        proteins: 26,
        carbs: 0,
        fats: 2.7,
        servingSize: 100,
        servingUnit: 'g',
      ),
      FoodItem(
        id: 'mandazi-1',
        name: 'Mandazi',
        calories: 230,
        proteins: 3.5,
        carbs: 30,
        fats: 11,
        servingSize: 1,
        servingUnit: 'piece',
      ),
      FoodItem(
        id: 'pilau-1',
        name: 'Pilau',
        calories: 180,
        proteins: 4.5,
        carbs: 32,
        fats: 4.2,
        servingSize: 100,
        servingUnit: 'g',
      ),
    ];

    // Add each food item to the batch
    for (var food in commonFoods) {
      final docRef = foodItemsCollection.doc(food.id);
      batch.set(docRef, food.toJson());
    }

    // Commit the batch
    await batch.commit();
  }
} 