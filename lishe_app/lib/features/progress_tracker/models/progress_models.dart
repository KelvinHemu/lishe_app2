import 'package:flutter/material.dart';

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

  List<double> toList() {
    return [
      proteinPercentage / 100,
      carbsPercentage / 100,
      fatsPercentage / 100,
      fiberPercentage / 100,
      vitaminsPercentage / 100,
    ];
  }
}

class ProgressDataPoint {
  final DateTime date;
  final double value;

  const ProgressDataPoint({
    required this.date,
    required this.value,
  });
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
  final String? details;

  const ActivityEntry({
    required this.title,
    required this.timestamp,
    required this.icon,
    required this.color,
    this.details,
  });

  String get timeString {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
} 