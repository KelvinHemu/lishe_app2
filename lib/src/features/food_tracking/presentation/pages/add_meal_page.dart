import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/food_item.dart';
import '../../models/meal_entry.dart';
import '../../services/food_tracking_service.dart';

class AddMealPage extends StatefulWidget {
  final DateTime selectedDate;

  const AddMealPage({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  final FoodTrackingService _foodTrackingService = FoodTrackingService();
  final TextEditingController _searchController = TextEditingController();
  final List<MealItem> _selectedItems = [];
  String _selectedMealType = 'Breakfast';
  List<FoodItem> _searchResults = [];
  bool _isSearching = false;

  final List<String> _mealTypes = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchFood(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final results = await _foodTrackingService.searchFoodItems(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching foods: ${e.toString()}')),
      );
    }
  }

  void _addFoodItem(FoodItem item) {
    setState(() {
      _selectedItems.add(MealItem(
        foodItem: item,
        servings: 1,
        notes: null,
      ));
      _searchController.clear();
      _searchResults = [];
    });
  }

  void _removeFoodItem(int index) {
    setState(() {
      _selectedItems.removeAt(index);
    });
  }

  void _updateServings(int index, double servings) {
    setState(() {
      _selectedItems[index] = MealItem(
        foodItem: _selectedItems[index].foodItem,
        servings: servings,
        notes: _selectedItems[index].notes,
      );
    });
  }

  Future<void> _saveMeal() async {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one food item')),
      );
      return;
    }

    try {
      final meal = MealEntry(
        id: const Uuid().v4(),
        timestamp: DateTime(
          widget.selectedDate.year,
          widget.selectedDate.month,
          widget.selectedDate.day,
          DateTime.now().hour,
          DateTime.now().minute,
        ),
        mealType: _selectedMealType,
        items: _selectedItems,
      );

      await _foodTrackingService.addMealEntry(meal);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving meal: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Meal',
          style: TextStyle(
            fontSize: 24,
            color: const Color.fromARGB(255, 13, 95, 133),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedMealType,
                  decoration: const InputDecoration(
                    labelText: 'Meal Type',
                    border: OutlineInputBorder(),
                  ),
                  items: _mealTypes
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedMealType = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search Foods',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: _searchFood,
                ),
              ],
            ),
          ),
          if (_isSearching)
            const Center(child: CircularProgressIndicator())
          else if (_searchResults.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final item = _searchResults[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text(
                        '${item.calories.toInt()} kcal per ${item.servingSize}${item.servingUnit}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => _addFoodItem(item),
                    ),
                  );
                },
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _selectedItems.length,
                itemBuilder: (context, index) {
                  final item = _selectedItems[index];
                  return ListTile(
                    title: Text(item.foodItem.name),
                    subtitle: Text(
                        '${(item.foodItem.calories * item.servings).toInt()} kcal'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            if (item.servings > 0.5) {
                              _updateServings(index, item.servings - 0.5);
                            }
                          },
                        ),
                        Text(item.servings.toString()),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () =>
                              _updateServings(index, item.servings + 0.5),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _removeFoodItem(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveMeal,
        child: const Icon(Icons.check),
        backgroundColor: const Color.fromARGB(255, 13, 95, 133),
      ),
    );
  }
} 