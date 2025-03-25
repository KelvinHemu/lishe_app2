import 'package:flutter/material.dart';

class AppBarItem {
  final IconData icon;
  final String label;
  final Function() onTap;

  const AppBarItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
