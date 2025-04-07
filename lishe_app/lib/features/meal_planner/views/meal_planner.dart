import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lishe_app/features/meal_planner/widgets/meal_planner/other_recipe_card.dart';

import '../../../core/common/widgets/top_app_bar.dart';
import '../controllers/meal_planner_controller.dart';
import '../models/app_bar_model.dart';
import '../models/meal.dart';
import '../services/meal_service.dart';
import '../widgets/meal_planner/current_meal_widget.dart';
import '../widgets/meal_planner/day_selector_widget.dart';
import '../widgets/meal_planner/meal_of_the_day_card.dart';
import 'explore_meals_page.dart';
import 'meal_detail_screen.dart';

class MealPlannerView extends StatefulWidget {
  const MealPlannerView({super.key});

  @override
  State<MealPlannerView> createState() => _MealPlannerViewState();
}

class _MealPlannerViewState extends State<MealPlannerView>
    with SingleTickerProviderStateMixin {
  final MockMealService _mockMealService = MockMealService();
  final MealPlannerController _controller = MealPlannerController();
  late DateTime _selectedDate;
  late List<DateTime> _weekDates;
  Meal? _featuredMeal;
  Meal? _nextMeal; // Add this to hold the next meal during transition
  late AnimationController _animationController;
  bool _isChangingMeal = false;

  // Add these variables for meal type toggle
  final List<String> _mealTypes = ['breakfast', 'lunch', 'dinner'];
  int _selectedMealTypeIndex = 0;
  // Map to hold meals for each meal type
  Map<String, Meal?> _mealsByType = {};

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

    // Initialize meal by type map
    _mealsByType = {
      'breakfast': _mockMealService.getSuggestedMealByType('breakfast'),
      'lunch': _mockMealService.getSuggestedMealByType('lunch'),
      'dinner': _mockMealService.getSuggestedMealByType('dinner'),
    };

    // Set the featured meal to the currently selected meal type
    _featuredMeal = _mealsByType[_mealTypes[_selectedMealTypeIndex]];

    // Initialize notification service
    _initializeNotifications();
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

  void _toggleMealType(int index) {
    if (_isChangingMeal || !mounted || _animationController.isAnimating) return;
    if (_selectedMealTypeIndex == index) return;

    setState(() {
      _isChangingMeal = true;
      _nextMeal = _mealsByType[_mealTypes[index]];
    });

    _animationController.forward().then((_) {
      if (!mounted) return;

      setState(() {
        _featuredMeal = _nextMeal;
        _selectedMealTypeIndex = index;
      });

      _animationController.reset();

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _isChangingMeal = false;
            _nextMeal = null;
          });
        }
      });
    });
  }

  Future<void> _initializeNotifications() async {
    try {
      await _controller.initialize();
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
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
            // Day selector - shows date navigation
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

            const SizedBox(height: 16),

            // Meal type toggle buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(
                  _mealTypes.length,
                  (index) => Expanded(
                    child: GestureDetector(
                      onTap: () => _toggleMealType(index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color:
                              _selectedMealTypeIndex == index
                                  ? Colors.green.shade100
                                  : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                _selectedMealTypeIndex == index
                                    ? Colors.green.shade500
                                    : Colors.grey.shade300,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            StringExtension(_mealTypes[index]).capitalize(),
                            style: TextStyle(
                              color:
                                  _selectedMealTypeIndex == index
                                      ? Colors.green.shade800
                                      : Colors.grey.shade700,
                              fontWeight:
                                  _selectedMealTypeIndex == index
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

            const SizedBox(height: 12),

            // Featured meal card with animation
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                if (_featuredMeal == null) {
                  return const SizedBox();
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
                          showHeader: true,
                          mealType: _mealTypes[_selectedMealTypeIndex],
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
                            showHeader: true,
                            mealType:
                                _mealTypes[_selectedMealTypeIndex ==
                                        _mealTypes.length - 1
                                    ? 0
                                    : _selectedMealTypeIndex + 1],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

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

            const SizedBox(height: 16),

            // Test notification button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
                        
                        // Show an immediate test notification
                        await flutterLocalNotificationsPlugin.show(
                          0,
                          'Test Notification',
                          'This is a test notification to verify if notifications are working',
                          const NotificationDetails(
                            android: AndroidNotificationDetails(
                              'meal_reminders',
                              'Meal Reminders',
                              channelDescription: 'Notifications for scheduled meals',
                              importance: Importance.max,
                              priority: Priority.high,
                              enableVibration: true,
                              enableLights: true,
                              ledColor: Color(0xFF4CAF50),
                              ledOnMs: 1000,
                              ledOffMs: 500,
                            ),
                          ),
                        );

                        // Schedule a test meal for 1 minute from now
                        final testMeal = Meal(
                          id: '999',
                          name: 'Test Meal',
                          calories: 500,
                          protein: 20.0,
                          carbs: 50.0,
                          fat: 15.0,
                          imageUrl: 'assets/images/test_meal.jpg',
                          ingredients: ['Test Ingredient 1', 'Test Ingredient 2'],
                          recipe: 'Test recipe instructions',
                          mealTypes: ['breakfast'],
                        );
                        
                        // Get current time in local timezone
                        final now = DateTime.now();
                        // Add 1 minute and 1 second to ensure it's in the future
                        final testTime = now.add(const Duration(minutes: 1, seconds: 1));
                        
                        await _controller.setMealForDate(testTime, 'breakfast', testMeal);
                        
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Test notification scheduled for ${testTime.toString()}'),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error scheduling notification: $e'),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Test Notification (1 min)'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
                        await flutterLocalNotificationsPlugin.show(
                          1,
                          'Immediate Test',
                          'This is an immediate test notification',
                          const NotificationDetails(
                            android: AndroidNotificationDetails(
                              'meal_reminders',
                              'Meal Reminders',
                              channelDescription: 'Notifications for scheduled meals',
                              importance: Importance.max,
                              priority: Priority.high,
                              enableVibration: true,
                              enableLights: true,
                              ledColor: Color(0xFF4CAF50),
                              ledOnMs: 1000,
                              ledOffMs: 500,
                            ),
                          ),
                        );
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error showing immediate notification: $e'),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Show Immediate Notification'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            CurrentMealWidget(
              controller: _controller,
              selectedDate: _selectedDate,
              onMealTap: (mealType) => _showMealSelectionDialog(mealType),
            ),

            const SizedBox(
              height: 24,
            ), // More bottom padding for better spacing
          ],
        ),
      ),
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
