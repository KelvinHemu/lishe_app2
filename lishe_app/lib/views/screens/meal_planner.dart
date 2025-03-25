import 'package:flutter/material.dart';
import 'package:lishe_app/views/widgets/meal_planner/other_recipe_card.dart';
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

class _MealPlannerViewState extends State<MealPlannerView>
    with SingleTickerProviderStateMixin {
  final MealPlannerController _controller = MealPlannerController();
  final MockMealService _mockMealService = MockMealService();
  late DateTime _selectedDate;
  late List<DateTime> _weekDates;
  Meal? _featuredMeal;
  Meal? _nextMeal; // Add this to hold the next meal during transition
  late AnimationController _animationController;
  bool _isChangingMeal = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600), // Slightly faster animation
    );

    // Initialize other variables
    _selectedDate = DateTime.now();
    _generateWeekDates();
    _loadInitialData();
    _featuredMeal = _mockMealService.getFeaturedMealOfTheDay();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

  // Modified method to update the featured meal with slide animation
  void _loadRandomMeal() {
    if (_isChangingMeal || !mounted || _animationController.isAnimating) return;

    setState(() {
      _isChangingMeal = true;
      _nextMeal =
          _mockMealService
              .getRandomMeal(); // Get the new meal but don't show it yet
    });

    _animationController.forward().then((_) {
      if (!mounted) return;

      setState(() {
        _featuredMeal =
            _nextMeal; // Update to the new meal when animation completes
      });

      _animationController.reset();

      // Add a short delay before allowing another change
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _isChangingMeal = false;
            _nextMeal = null; // Clean up
          });
        }
      });
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

            // Featured meal card with slide animation
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                if (_featuredMeal == null) {
                  return const SizedBox(); // Return an empty widget if meal is null
                }

                // Calculate slide position
                final slideValue = _animationController.value;

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Current meal sliding out
                    Transform.translate(
                      offset: Offset(
                        -slideValue * MediaQuery.of(context).size.width,
                        0,
                      ),
                      child: Opacity(
                        opacity: 1.0 - slideValue,
                        child: MealOfTheDayCard(
                          meal: _featuredMeal,
                          onTap: () {
                            if (_featuredMeal != null && !_isChangingMeal) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => MealDetailScreen(
                                        meal: _featuredMeal!,
                                      ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),

                    // New meal sliding in
                    if (_nextMeal != null)
                      Transform.translate(
                        offset: Offset(
                          (1.0 - slideValue) *
                              MediaQuery.of(context).size.width,
                          0,
                        ),
                        child: Opacity(
                          opacity: slideValue,
                          child: MealOfTheDayCard(
                            meal: _nextMeal,
                            onTap: null, // Disabled during animation
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),

            const SizedBox(height: 8),

            // Random recipe widget
            RandomRecipeWidget(
              onRandomPressed: _loadRandomMeal,
              onExplorePressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExploreMealsPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20), // Keep some bottom padding
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
