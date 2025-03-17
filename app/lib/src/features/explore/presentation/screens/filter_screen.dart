import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lishe_app2/src/features/explore/presentation/screens/filtered_recipes_screen.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String selectedMealType = 'All';
  String selectedCuisine = 'All';
  List<String> selectedDietary = [];
  RangeValues preparationTime = const RangeValues(10, 60);

  bool get _hasActiveFilters =>
    selectedMealType != 'All' ||
    selectedCuisine != 'All' ||
    selectedDietary.isNotEmpty ||
    preparationTime.start != 10 ||
    preparationTime.end != 60;

  void _clearAll() {
    setState(() {
      selectedMealType = 'All';
      selectedCuisine = 'All';
      selectedDietary = [];
      preparationTime = const RangeValues(10, 60);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All filters cleared'),
        backgroundColor: Colors.blue[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          title: const Text(
            'Filter',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton.icon(
                onPressed: _hasActiveFilters ? _clearAll : null,
                icon: Icon(
                  Icons.refresh,
                  size: 20,
                  color: _hasActiveFilters ? Colors.blue[700] : Colors.grey[400],
                ),
                label: Text(
                  'Clear all',
                  style: TextStyle(
                    color: _hasActiveFilters ? Colors.blue[700] : Colors.grey[400],
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Meal Type Section
                    Text(
                      'Meal Type',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'All',
                        'Breakfast',
                        'Lunch',
                        'Dinner',
                        'Snacks',
                        'Dessert'
                      ].map((type) => ChoiceChip(
                        label: Text(type),
                        selected: selectedMealType == type,
                        selectedColor: Colors.blue[200],
                        checkmarkColor: Colors.blue[700],
                        labelStyle: TextStyle(
                          color: selectedMealType == type ? Colors.blue[700] : Colors.black87,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            selectedMealType = type;
                          });
                        },
                      )).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Cuisine Section
                    Text(
                      'Cuisine',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'All',
                        'Italian',
                        'Chinese',
                        'Indian',
                        'Mexican',
                        'Japanese',
                        'Thai',
                        'Mediterranean',
                        'American'
                      ].map((cuisine) => ChoiceChip(
                        label: Text(cuisine),
                        selected: selectedCuisine == cuisine,
                        selectedColor: Colors.blue[200],
                        checkmarkColor: Colors.blue[700],
                        labelStyle: TextStyle(
                          color: selectedCuisine == cuisine ? Colors.blue[700] : Colors.black87,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            selectedCuisine = cuisine;
                          });
                        },
                      )).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Dietary Preferences Section
                    Text(
                      'Dietary Preferences',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'Vegetarian',
                        'Vegan',
                        'Gluten-Free',
                        'Dairy-Free',
                        'Low-Carb',
                        'Keto',
                        'Paleo'
                      ].map((pref) => FilterChip(
                        label: Text(pref),
                        selected: selectedDietary.contains(pref),
                        selectedColor: Colors.blue[200],
                        checkmarkColor: Colors.blue[700],
                        labelStyle: TextStyle(
                          color: selectedDietary.contains(pref) ? Colors.blue[700] : Colors.black87,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedDietary.add(pref);
                            } else {
                              selectedDietary.remove(pref);
                            }
                          });
                        },
                      )).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Preparation Time Section
                    Text(
                      'Preparation Time (minutes)',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RangeSlider(
                      values: preparationTime,
                      min: 0,
                      max: 120,
                      divisions: 12,
                      activeColor: Colors.blue[500],
                      inactiveColor: Colors.blue[100],
                      labels: RangeLabels(
                        '${preparationTime.start.round()} min',
                        '${preparationTime.end.round()} min',
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          preparationTime = values;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${preparationTime.start.round()} min',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text('${preparationTime.end.round()} min',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Apply Filter Button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final filters = {
                          'mealType': selectedMealType,
                          'cuisine': selectedCuisine,
                          'dietaryPreferences': selectedDietary,
                          'preparationTime': preparationTime,
                        };
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FilteredRecipesScreen(
                              filters: filters,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}