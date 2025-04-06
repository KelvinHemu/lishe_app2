import 'package:flutter/material.dart';

import '../models/navigation_model.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  final List<NavigationItem> items = [
    const NavigationItem(
      label: 'Home',
      icon: Icons.home_rounded,
      path: '/home',
    ),
    const NavigationItem(
      label: 'Progress',
      icon: Icons.bar_chart_rounded,
      path: '/progress-tracker',
    ),
    const NavigationItem(
      label: 'Meals',
      icon: Icons.restaurant_menu_rounded,
      path: '/meals',
    ),
    const NavigationItem(
      label: 'Profile',
      icon: Icons.person_rounded,
      path: '/profile',
    ),
  ];

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    if (index != _currentIndex) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  String get currentPath => items[_currentIndex].path;

  int getIndexFromPath(String path) {
    for (int i = 0; i < items.length; i++) {
      if (path.startsWith(items[i].path)) {
        return i;
      }
    }
    return 0; // Default to home
  }
}
