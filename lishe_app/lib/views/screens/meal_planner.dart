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
import '../../services/meal_service.dart';
import '../screens/meal_detail_screen.dart';
import '../screens/explore_meals_page.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _generateWeekDates();
    _loadInitialData();
    _featuredMeal = _mockMealService.getFeaturedMealOfTheDay();
  }

  Future<void> _loadInitialData() async {
    try {
      _controller.loadMealsForDate(_selectedDate);
      _featuredMeal = _mockMealService.getFeaturedMealOfTheDay();
      if (mounted) {
        setState(() {});
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
                if (_featuredMeal != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => MealDetailScreen(meal: _featuredMeal!),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No meal details available')),
                  );
                }
              },
            ),
            const SizedBox(height: 8),
            RandomRecipeWidget(
              onRandomPressed: () {
                setState(() {
                  // Show loading indicator
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Finding a random meal for you...'),
                      duration: Duration(milliseconds: 800),
                    ),
                  );

                  // Get a random meal
                  final randomMeal = _mockMealService.getRandomMeal();

                  // Navigate to the meal details after a short delay (for animation)
                  Future.delayed(const Duration(milliseconds: 1000), () {
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MealDetailScreen(meal: randomMeal),
                        ),
                      );
                    }
                  });
                });
              },
              onExplorePressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExploreMealsPage(),
                  ),
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
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ExploreMealsPage(),
                            ),
                          );
                        },
                        child: FoodPictureWidget(imageUrl: url, size: 100),
                      ),
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
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
