import 'package:flutter/material.dart';

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
