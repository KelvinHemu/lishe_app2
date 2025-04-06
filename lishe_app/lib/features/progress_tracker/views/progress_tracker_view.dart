import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common/widgets/top_app_bar.dart';
import '../../meal_planner/models/app_bar_model.dart';

// Models for API integration
class NutritionData {
  final double proteinPercentage;
  final double carbsPercentage;
  final double fatsPercentage;
  final double fiberPercentage;
  final double vitaminsPercentage;

  const NutritionData({
    required this.proteinPercentage,
    required this.carbsPercentage,
    required this.fatsPercentage,
    required this.fiberPercentage,
    required this.vitaminsPercentage,
  });

  List<double> toList() => [
    proteinPercentage,
    carbsPercentage,
    fatsPercentage,
    fiberPercentage,
    vitaminsPercentage
  ];
}

class ProgressDataPoint {
  final DateTime date;
  final double value;

  const ProgressDataPoint({required this.date, required this.value});
}

class ProgressData {
  final List<ProgressDataPoint> calorieData;
  final List<ProgressDataPoint> proteinData;
  final List<ProgressDataPoint> weightData;

  const ProgressData({
    required this.calorieData,
    required this.proteinData,
    required this.weightData,
  });
}

class ActivityEntry {
  final String title;
  final DateTime timestamp;
  final IconData icon;
  final Color color;

  const ActivityEntry({
    required this.title,
    required this.timestamp,
    required this.icon,
    required this.color,
  });

  String get timeString {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return 'Yesterday';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}

// Controller for data integration
class ProgressTrackerController {
  String? _currentFilter;
  DateTimeRange? _dateRange;

  // Set filters
  void setFilter(String filterType) {
    _currentFilter = filterType;
  }

  void clearFilter() {
    _currentFilter = null;
  }

  void setDateRange(DateTimeRange range) {
    _dateRange = range;
  }

  // Sample data - replace with API calls
  NutritionData getNutritionData() {
    return const NutritionData(
      proteinPercentage: 80,
      carbsPercentage: 65,
      fatsPercentage: 90,
      fiberPercentage: 70,
      vitaminsPercentage: 85,
    );
  }

  ProgressData getProgressData() {
    final now = DateTime.now();
    return ProgressData(
      calorieData: List.generate(7, (i) {
        return ProgressDataPoint(
          date: now.subtract(Duration(days: 6 - i)),
          value: 1800 + math.Random().nextInt(700).toDouble(),
        );
      }),
      proteinData: List.generate(7, (i) {
        return ProgressDataPoint(
          date: now.subtract(Duration(days: 6 - i)),
          value: 60 + math.Random().nextInt(40).toDouble(),
        );
      }),
      weightData: List.generate(7, (i) {
        final base = 65.2;
        return ProgressDataPoint(
          date: now.subtract(Duration(days: 6 - i)),
          value: base - (i * 0.1),
        );
      }),
    );
  }

  List<ActivityEntry> getRecentActivities() {
    final now = DateTime.now();
    return [
      ActivityEntry(
        title: 'Completed daily meal plan',
        timestamp: now.subtract(const Duration(hours: 2)),
        icon: Icons.restaurant,
        color: Colors.orange,
      ),
      ActivityEntry(
        title: 'Logged breakfast',
        timestamp: now.subtract(const Duration(hours: 5)),
        icon: Icons.free_breakfast,
        color: Colors.blue,
      ),
      ActivityEntry(
        title: 'Updated weight',
        timestamp: now.subtract(const Duration(days: 1)),
        icon: Icons.monitor_weight,
        color: Colors.green,
      ),
    ];
  }

  Map<String, dynamic> getSummaryData() {
    return {
      'weight': '64.5',
      'weightChange': '-0.7',
      'calories': '2,100',
      'caloriesPercentage': 85,
      'steps': '8,456',
      'stepsPercentage': 84,
      'bmi': '22.4',
      'bmiStatus': 'Healthy',
    };
  }

  // API integration methods - to be implemented
  Future<NutritionData> fetchNutritionData() async {
    // TODO: Implement API call
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
    return getNutritionData();
  }
  
  Future<ProgressData> fetchProgressData() async {
    // TODO: Implement API call
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
    return getProgressData();
  }
  
  Future<List<ActivityEntry>> fetchRecentActivities() async {
    // TODO: Implement API call
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
    return getRecentActivities();
  }
  
  Future<Map<String, dynamic>> fetchSummaryData() async {
    // TODO: Implement API call
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
    return getSummaryData();
  }
}

class ProgressTrackerView extends StatefulWidget {
  const ProgressTrackerView({super.key});

  @override
  State<ProgressTrackerView> createState() => _ProgressTrackerViewState();
}

class _ProgressTrackerViewState extends State<ProgressTrackerView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ProgressTrackerController _controller;
  
  ProgressData? _progressData;
  NutritionData? _nutritionData;
  List<ActivityEntry>? _activities;
  Map<String, dynamic>? _summaryData;
  
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _controller = ProgressTrackerController();
    print('ProgressTrackerView initialized'); // Debug print
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // In a real app, these would be parallel requests
      final nutritionData = await _controller.fetchNutritionData();
      final progressData = await _controller.fetchProgressData();
      final activities = await _controller.fetchRecentActivities();
      final summaryData = await _controller.fetchSummaryData();
      
      // Only update state if widget is still mounted
      if (mounted) {
        setState(() {
          _nutritionData = nutritionData;
          _progressData = progressData;
          _activities = activities;
          _summaryData = summaryData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load data. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Progress',
        actions: [
          AppBarItem(
            icon: Icons.notifications_outlined,
            label: 'Notifications',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications coming soon!'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          AppBarItem(
            icon: Icons.person_outline,
            label: 'Profile',
            onTap: () {
              context.go('/profile');
            },
          ),
        ],
      ),
      body: _buildBody(theme),
    );
  }
  
  Widget _buildBody(ThemeData theme) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        children: [
          _buildLoggingProgressCard(theme),
          const SizedBox(height: 20),
          _buildCalorieCard(theme),
          const SizedBox(height: 20),
          _buildKeepItUpSection(theme),
          const SizedBox(height: 20),
           // Extra space for bottom nav bar
        ],
      ),
    );
  }
  
  Widget _buildLoggingProgressCard(ThemeData theme) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green,
              Color(0xFF006400), // Dark green
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_fire_department_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "You're on fire!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "You've logged 3 meals and 60g of protein today.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: 0.65,
                minHeight: 12,
                backgroundColor: Colors.white.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  "Day progress: 65%",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.access_time,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  "Updated 30m ago",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCalorieCard(ThemeData theme) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.restaurant_menu,
                  color: theme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  "Total Calories Today",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Today",
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            
            // Main calories and progress
            Row(
              children: [
                // Left side - calories info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Total calories
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "1,850",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            "kcal",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Recommended value
                    Row(
                      children: [
                        Icon(
                          Icons.compass_calibration,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Recommended: 2,000 kcal/day",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Status message
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "Within healthy range!",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const Spacer(),
                
                // Right side - small circular indicator
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: 0.925, // 1850/2000 = 0.925
                        strokeWidth: 6,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "93%",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            "of goal",
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 15),
            const Divider(height: 1),
            const SizedBox(height: 30),
            
            // Nutrient Breakdown Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.balance,
                      color: theme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Nutrient Breakdown",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        // Show detailed explanation when tapped
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Detailed nutrition report coming soon!'),
                            duration: Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                            Icon(
                              Icons.info_outline,
                              size: 12,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Details",
                          style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
            ),
          ],
        ),
                const SizedBox(height: 8),
                Text(
                  "Here's what your body got today:",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Improved Nutrient Cards
                _buildNutrientCard(
                  emoji: "🍞",
                  name: "Carbs",
                  amount: "250g",
                  status: "✅ Good",
                  statusColor: Colors.green,
                  percentage: 0.83, // 250g out of ~300g recommended
                  backgroundColor: Colors.amber.withValues(alpha: 0.08),
                  theme: theme,
                ),
                
                const SizedBox(height: 10),
                
                _buildNutrientCard(
                  emoji: "🍳",
                  name: "Protein",
                  amount: "60g",
                  status: "⚠️ Slightly Low",
                  statusColor: Colors.orange,
                  percentage: 0.62, // 60g out of ~100g recommended
                  backgroundColor: Colors.blue.withValues(alpha: 0.08),
                  theme: theme,
                ),
                
                const SizedBox(height: 10),
                
                _buildNutrientCard(
                  emoji: "🥑",
                  name: "Fats",
                  amount: "70g",
                  status: "✅ Balanced",
                  statusColor: Colors.green,
                  percentage: 0.78, // 70g out of ~90g recommended
                  backgroundColor: Colors.green.withValues(alpha: 0.08),
                  theme: theme,
                ),
                
                const SizedBox(height: 10),
                
                _buildNutrientCard(
                  emoji: "💧",
                  name: "Water",
                  amount: "1.2L",
                  status: "🚱 Try to drink more",
                  statusColor: Colors.red,
                  percentage: 0.48, // 1.2L out of 2.5L recommended
                  backgroundColor: Colors.blue.withValues(alpha: 0.08),
                  isWater: true,
                  theme: theme,
                ),
        ],
      ),
            
            const SizedBox(height: 15),
            const Divider(height: 1),
            const SizedBox(height: 15),
            
            // Health Tip of the Day
            Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                    Icon(
                      Icons.health_and_safety,
                      color: theme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                const Text(
                      "Health Tip of the Day",
                  style: TextStyle(
                        fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                  ],
                ),
                const SizedBox(height: 16),
                
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "💬",
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                  child: Text(
                          "You're doing well! Try adding a banana or some spinach tomorrow to improve potassium and fiber.",
                    style: TextStyle(
                            fontSize: 15,
                            height: 1.4,
                            color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
                ),
              ],
            ),
            
            const SizedBox(height: 15),
            const Divider(height: 1),
            const SizedBox(height: 15),
            
            // Daily Score Section
            Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
                    Icon(
                      Icons.trending_up,
                      color: theme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Your Daily Score",
                      style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ],
                ),
                const SizedBox(height: 16),
                
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                  ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                            "🥗 Nutrition Score:",
                  style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                ),
              ],
            ),
                            child: const Text(
                              "8/10",
                          style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                    ),
                  ],
                ),
                      const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                            padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                            child: const Icon(
                              Icons.thumb_up,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "You made healthy choices today!",
                          style: TextStyle(
                              fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Keep It Up Section
  Widget _buildKeepItUpSection(ThemeData theme) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Text(
                  "🔄 Keep It Up!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Streaks",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // 3-day streak section
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    "🔥",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                const SizedBox(width: 15),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "3-day streak",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "of balanced eating",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 20),
            
            // Goal progress section
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    "🎯",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Getting closer to your goal:",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Healthy Weight",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 15),
            
            // Progress bar for goal
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: 0.7,
                minHeight: 8,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Starting point",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const Text(
                  "70% complete",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  "Goal",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientCard({
    required String emoji,
    required String name,
    required String amount,
    required String status,
    required Color statusColor,
    required double percentage,
    required Color backgroundColor,
    required ThemeData theme,
    bool isWater = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
            children: [
              // Nutrient with emoji
              Row(
                children: [
                  Text(
                    emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              
                const Spacer(),
              
              // Amount with pill background
                Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          
          const SizedBox(height: 8),
          
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 6,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                isWater ? Colors.blue : statusColor,
              ),
            ),
          ),
          
          const SizedBox(height: 6),
          
          // Status text
          Row(
                  children: [
              Icon(
                isWater ? Icons.water_drop :
                  percentage < 0.6 ? Icons.warning_amber_rounded :
                  Icons.check_circle,
                color: statusColor,
                size: 16,
              ),
              const SizedBox(width: 6),
                    Text(
                status,
                      style: TextStyle(
                  fontSize: 13,
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                      ),
                ),
                const Spacer(),
                    Text(
                      "${(percentage * 100).toInt()}%",
                      style: TextStyle(
                  fontSize: 13,
                        color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
      ),
    );
  }
} 