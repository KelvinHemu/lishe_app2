import 'package:flutter/material.dart';
import 'package:lishe_app/views/widgets/meal_planner/other_recipe_card.dart';
import '../widgets/meal_planner/food_picture_widget.dart';
import '../../controllers/meal_planner_controller.dart';
import '../../models/meal.dart';
import '../widgets/meal_planner/day_selector_widget.dart';
import '../widgets/meal_planner/meal_type_cards_widget.dart';
import '../widgets/meal_planner/current_meal_widget.dart';
import '../widgets/meal_planner/meal_of_the_day_card.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/top_app_bar.dart';
import '../../models/app_bar_model.dart';
import '../../services/mock_meal_service.dart';

class MealPlannerView extends StatefulWidget {
  const MealPlannerView({super.key});

  @override
  State<MealPlannerView> createState() => _MealPlannerViewState();
}

class _MealPlannerViewState extends State<MealPlannerView> {
  final MealPlannerController _controller = MealPlannerController();
  final MockMealService _mockMealService = MockMealService();
  late DateTime _selectedDate;
  late List<DateTime> _weekDates;
  Meal? _featuredMeal;
  List<String> _foodImages = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _generateWeekDates();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      _controller.loadMealsForDate(_selectedDate);
      _featuredMeal = _mockMealService.getFeaturedMealOfTheDay();
      if (mounted) {
        setState(() {
          _foodImages = _mockMealService.getMockFoodImages();
        });
      }
    } catch (e) {
      debugPrint('Error loading initial data: $e');
    }
  }

  void _generateWeekDates() {
    final now = DateTime.now();
    final int currentWeekday = now.weekday;

    _weekDates = List.generate(7, (index) {
      return now.subtract(Duration(days: currentWeekday - 1 - index));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Meal Planner',
        actions: [
          AppBarItem(
            icon: Icons.calendar_today,
            label: 'Calendar',
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );

              if (pickedDate != null && pickedDate != _selectedDate) {
                setState(() {
                  _selectedDate = pickedDate;
                  _controller.loadMealsForDate(_selectedDate);

                  final int selectedWeekday = pickedDate.weekday;
                  final DateTime weekStart = pickedDate.subtract(
                    Duration(days: selectedWeekday - 1),
                  );

                  _weekDates = List.generate(7, (index) {
                    return weekStart.add(Duration(days: index));
                  });
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DaySelectorWidget(
              weekDates: _weekDates,
              selectedDate: _selectedDate,
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                  _controller.loadMealsForDate(_selectedDate);
                });
              },
            ),
            MealTypeCardsWidget(
              selectedDate: _selectedDate,
              controller: _controller,
              onMealTap: (mealType) => _showMealSelectionDialog(mealType),
            ),
            const SizedBox(height: 8),
            CurrentMealWidget(controller: _controller),
            const SizedBox(height: 8),
            MealOfTheDayCard(
              meal: _featuredMeal,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Viewing ${_featuredMeal?.name ?? "meal"} details',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            RandomRecipeWidget(
              onRandomPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fetching a random recipe...')),
                );
              },
              onExplorePressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exploring recipes...')),
                );
              },
            ),
            const SizedBox(height: 18),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Use the working hardcoded approach, but with FoodPictureWidget
                  ..._mockMealService.getMockFoodImages().map((url) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: FoodPictureWidget(imageUrl: url, size: 100),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  void _showMealSelectionDialog(String mealType) {
    // Existing dialog implementation...
  }

  Widget _buildTestFoodImage(String url) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, _) => Container(
                  color: Colors.red[100],
                  child: const Icon(Icons.error),
                ),
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
