import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/progress_models.dart';

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
    try {
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
      return getNutritionData();
    } catch (e) {
      print('Error fetching nutrition data: $e');
      rethrow;
    }
  }
  
  Future<ProgressData> fetchProgressData() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
      return getProgressData();
    } catch (e) {
      print('Error fetching progress data: $e');
      rethrow;
    }
  }
  
  Future<List<ActivityEntry>> fetchRecentActivities() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
      return getRecentActivities();
    } catch (e) {
      print('Error fetching activities: $e');
      rethrow;
    }
  }
  
  Future<Map<String, dynamic>> fetchSummaryData() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
      return getSummaryData();
    } catch (e) {
      print('Error fetching summary data: $e');
      rethrow;
    }
  }
}