import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/food_item.dart';
import '../models/meal_entry.dart';

class FoodTrackingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get user's food diary for a specific date
  Future<List<MealEntry>> getMealEntriesForDate(DateTime date) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('meal_entries')
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
        .where('timestamp', isLessThan: endOfDay)
        .get();

    return snapshot.docs
        .map((doc) => MealEntry.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  // Add a new meal entry
  Future<String> addMealEntry(MealEntry entry) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final docRef = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('meal_entries')
        .add(entry.toJson());

    return docRef.id;
  }

  // Update an existing meal entry
  Future<void> updateMealEntry(MealEntry entry) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('meal_entries')
        .doc(entry.id)
        .update(entry.toJson());
  }

  // Delete a meal entry
  Future<void> deleteMealEntry(String entryId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('meal_entries')
        .doc(entryId)
        .delete();
  }

  // Search for food items in the database
  Future<List<FoodItem>> searchFoodItems(String query) async {
    final snapshot = await _firestore
        .collection('food_items')
        .where('name', isGreaterThanOrEqualTo: query.toLowerCase())
        .where('name', isLessThanOrEqualTo: query.toLowerCase() + '\uf8ff')
        .limit(20)
        .get();

    return snapshot.docs
        .map((doc) => FoodItem.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  // Add a custom food item
  Future<String> addCustomFoodItem(FoodItem foodItem) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final docRef = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('custom_food_items')
        .add(foodItem.toJson());

    return docRef.id;
  }

  // Get user's nutrition summary for a specific date
  Future<Map<String, double>> getNutritionSummary(DateTime date) async {
    final entries = await getMealEntriesForDate(date);
    
    double totalCalories = 0;
    double totalProteins = 0;
    double totalCarbs = 0;
    double totalFats = 0;

    for (var entry in entries) {
      totalCalories += entry.totalCalories;
      totalProteins += entry.totalProteins;
      totalCarbs += entry.totalCarbs;
      totalFats += entry.totalFats;
    }

    return {
      'calories': totalCalories,
      'proteins': totalProteins,
      'carbs': totalCarbs,
      'fats': totalFats,
    };
  }
} 