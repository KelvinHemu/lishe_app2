import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/meal_service.dart';
import '../widgets/meal_planner/meal_of_the_day_card.dart';
import '../../../core/common/widgets/top_app_bar.dart';
import '../models/app_bar_model.dart';
import 'meal_detail_screen.dart';

class CustomMealPlanScreen extends StatefulWidget {
  final DateTime selectedDate;
  final List<String> mealTypes;
  final Map<String, Meal?> currentMeals;

  const CustomMealPlanScreen({
    Key? key,
    required this.selectedDate,
    required this.mealTypes,
    required this.currentMeals,
  }) : super(key: key);

  @override
  State<CustomMealPlanScreen> createState() => _CustomMealPlanScreenState();
}

class _CustomMealPlanScreenState extends State<CustomMealPlanScreen> {
  final MockMealService _mealService = MockMealService();
  late Map<String, Meal?> _selectedMeals;
  late int _selectedMealTypeIndex;
  late List<Meal> _availableMeals;
  final bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedMealTypeIndex = 0;
    // Initialize with current meals from widget
    _selectedMeals = Map.from(widget.currentMeals);
    // Load available meals for the current meal type
    _loadAvailableMeals();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadAvailableMeals() {
    // Get meal suggestions for the current meal type
    final mealType = widget.mealTypes[_selectedMealTypeIndex];
    _availableMeals = _mealService.getMealsByType(mealType);
    setState(() {});
  }

  void _selectMeal(Meal meal) {
    setState(() {
      final mealType = widget.mealTypes[_selectedMealTypeIndex];
      _selectedMeals[mealType] = meal;
    });
  }

  void _toggleMealType(int index) {
    setState(() {
      _selectedMealTypeIndex = index;
      _loadAvailableMeals();
      _searchQuery = '';
      _searchController.clear();
    });
  }

  void _searchMeals(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  List<Meal> get _filteredMeals {
    if (_searchQuery.isEmpty) {
      return _availableMeals;
    }
    return _availableMeals.where((meal) {
      return meal.name.toLowerCase().contains(_searchQuery) ||
          meal.description.toLowerCase().contains(_searchQuery) ||
          meal.ingredients.any(
              (ingredient) => ingredient.toLowerCase().contains(_searchQuery));
    }).toList();
  }

  Future<void> _saveMealPlan() async {
    // Here you would implement saving to a persistent storage
    // For now, we'll just navigate back with the selected meals
    Navigator.of(context).pop(_selectedMeals);
  }

  @override
  Widget build(BuildContext context) {
    final mealType = widget.mealTypes[_selectedMealTypeIndex];
    final currentSelectedMeal = _selectedMeals[mealType];

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Create Custom Meal Plan',
        showBackButton: true,
        actions: [
          AppBarItem(
            icon: Icons.save,
            label: 'Save',
            onTap: _saveMealPlan,
          ),
        ],
      ),
      body: Column(
        children: [
          // Date and description
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Custom plan for ${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Select meals for each part of your day',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Meal type selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(
                widget.mealTypes.length,
                (index) => Expanded(
                  child: GestureDetector(
                    onTap: () => _toggleMealType(index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _selectedMealTypeIndex == index
                            ? Colors.blue.shade100
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _selectedMealTypeIndex == index
                              ? Colors.blue.shade500
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          widget.mealTypes[index][0].toUpperCase() +
                              widget.mealTypes[index].substring(1),
                          style: TextStyle(
                            color: _selectedMealTypeIndex == index
                                ? Colors.blue.shade800
                                : Colors.grey.shade700,
                            fontWeight: _selectedMealTypeIndex == index
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Currently selected meal for this type
          if (currentSelectedMeal != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your current selection:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  MealOfTheDayCard(
                    meal: currentSelectedMeal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MealDetailScreen(
                            meal: currentSelectedMeal,
                          ),
                        ),
                      );
                    },
                    showHeader: false,
                    mealType: mealType,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for meals...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchMeals('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: _searchMeals,
            ),
          ),

          const SizedBox(height: 16),

          // Available meals list
          Expanded(
            child: _filteredMeals.isEmpty
                ? const Center(
                    child: Text(
                      'No meals found',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredMeals.length,
                    itemBuilder: (context, index) {
                      final meal = _filteredMeals[index];
                      final isSelected = currentSelectedMeal?.id == meal.id;

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected
                                ? Colors.blue.shade300
                                : Colors.transparent,
                            width: isSelected ? 2 : 0,
                          ),
                        ),
                        child: InkWell(
                          onTap: () => _selectMeal(meal),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                // Meal image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    meal.imageUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey.shade300,
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Meal details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        meal.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.local_fire_department,
                                            size: 16,
                                            color: Colors.orange.shade700,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${meal.calories} kcal',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Icon(
                                            Icons.access_time,
                                            size: 16,
                                            color: Colors.blue.shade700,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            meal.preparationTime,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Selection indicator
                                if (isSelected)
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.blue.shade800,
                                      size: 16,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
