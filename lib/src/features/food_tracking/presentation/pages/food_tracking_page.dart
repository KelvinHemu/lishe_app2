import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/meal_entry.dart';
import '../../services/food_tracking_service.dart';
import '../widgets/meal_list_item.dart';
import '../widgets/nutrition_summary_card.dart';
import 'add_meal_page.dart';

class FoodTrackingPage extends StatefulWidget {
  const FoodTrackingPage({super.key});

  @override
  State<FoodTrackingPage> createState() => _FoodTrackingPageState();
}

class _FoodTrackingPageState extends State<FoodTrackingPage> {
  final FoodTrackingService _foodTrackingService = FoodTrackingService();
  DateTime _selectedDate = DateTime.now();
  List<MealEntry> _meals = [];
  Map<String, double> _nutritionSummary = {
    'calories': 0,
    'proteins': 0,
    'carbs': 0,
    'fats': 0,
  };

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    try {
      final meals = await _foodTrackingService.getMealEntriesForDate(_selectedDate);
      final summary = await _foodTrackingService.getNutritionSummary(_selectedDate);
      setState(() {
        _meals = meals;
        _nutritionSummary = summary;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading meals: ${e.toString()}')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _loadMeals();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Food Diary',
          style: TextStyle(
            fontSize: 24,
            color: const Color.fromARGB(255, 13, 95, 133),
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              DateFormat('EEEE, MMMM d').format(_selectedDate),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          NutritionSummaryCard(nutritionSummary: _nutritionSummary),
          Expanded(
            child: ListView.builder(
              itemCount: _meals.length,
              itemBuilder: (context, index) {
                return MealListItem(
                  meal: _meals[index],
                  onDelete: () async {
                    await _foodTrackingService.deleteMealEntry(_meals[index].id);
                    _loadMeals();
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMealPage(selectedDate: _selectedDate),
            ),
          );
          _loadMeals();
        },
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 13, 95, 133),
      ),
    );
  }
} 