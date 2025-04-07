// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common/widgets/top_app_bar.dart';
import '../../meal_planner/models/app_bar_model.dart';
import '../controllers/data_integration.dart';
import '../models/progress_models.dart';

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
      print('Error loading data: $e'); // Debug print
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load data: ${e.toString()}';
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
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
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
        padding: const EdgeInsets.all(10),
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
                  "Weekly Progress",
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
              "You've logged 21 meals and 420g of protein this week.",
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
                value: 0.85,
                minHeight: 12,
                backgroundColor: Colors.white.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  "Week progress: 85%",
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
                  "Updated yesterday",
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
        padding: const EdgeInsets.all(10),
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
                  "Weekly Nutrition Summary",
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
                    "This Week",
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
                          "12,850",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            "kcal/week",
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
                          "Recommended: 14,000 kcal/week",
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
                        value: 0.918, // 12850/14000 = 0.918
                        strokeWidth: 6,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "92%",
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
                      "Weekly Nutrient Breakdown",
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
                  "Your weekly nutrient intake:",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Improved Nutrient Cards in horizontal layout
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildNutrientCard(
                        emoji: "🍞",
                        name: "Carbs",
                        amount: "1750g",
                        status: "✅ Good",
                        statusColor: Colors.green,
                        percentage: 0.83, // 1750g out of ~2100g recommended weekly
                        backgroundColor: Colors.amber.withValues(alpha: 0.08),
                        theme: theme,
                      ),
                      
                      const SizedBox(width: 10),
                      
                      _buildNutrientCard(
                        emoji: "🍳",
                        name: "Protein",
                        amount: "420g",
                        status: "⚠️ Slightly Low",
                        statusColor: Colors.orange,
                        percentage: 0.62, // 420g out of ~700g recommended weekly
                        backgroundColor: Colors.blue.withValues(alpha: 0.08),
                        theme: theme,
                      ),
                      
                      const SizedBox(width: 10),
                      
                      _buildNutrientCard(
                        emoji: "🥑",
                        name: "Fats",
                        amount: "490g",
                        status: "✅ Balanced",
                        statusColor: Colors.green,
                        percentage: 0.78, // 490g out of ~630g recommended weekly
                        backgroundColor: Colors.green.withValues(alpha: 0.08),
                        theme: theme,
                      ),
                      
                      const SizedBox(width: 10),
                      
                      _buildNutrientCard(
                        emoji: "💧",
                        name: "Water",
                        amount: "8.4L",
                        status: "🚱 Try to drink more",
                        statusColor: Colors.red,
                        percentage: 0.48, // 8.4L out of 17.5L recommended weekly
                        backgroundColor: Colors.blue.withValues(alpha: 0.08),
                        isWater: true,
                        theme: theme,
                      ),
                    ],
                  ),
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
                      "Weekly Health Insight",
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
                          "Your protein intake has been consistent this week. Try adding more green vegetables on weekends for better fiber balance.",
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
                      "Your Weekly Score",
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
                            "You maintained healthy choices this week!",
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
                    "Weekly Streaks",
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
                      "3-week streak",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "of balanced nutrition",
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
    final Color progressColor = isWater ? Colors.blue : statusColor;
    
    return Container(
      width: 280, // Set a fixed width for the card
      margin: const EdgeInsets.symmetric(vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Left side: Circular progress indicator
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: percentage,
                  strokeWidth: 6,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Right side: Nutrient details
          Flexible( // Changed from Expanded to Flexible
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nutrient name and amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
                
                // Percentage and status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${(percentage * 100).toInt()}% of weekly goal",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 4),
                
                // Status
                Row(
                  children: [
                    Icon(
                      isWater ? Icons.water_drop :
                      percentage < 0.6 ? Icons.warning_amber_rounded :
                      Icons.check_circle,
                      color: statusColor,
                      size: 14,
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
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 