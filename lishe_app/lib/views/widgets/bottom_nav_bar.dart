// Example usage in a page file
import 'package:flutter/material.dart';
import '../../models/navigation_model.dart';
import '../../routes/app_navigator.dart';
import '../screens/meal_planner.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final int _selectedIndex = 0;

  // List of screens to navigate between
  final List<Widget> _screens = [
    // Replace with your actual screens
    const Center(child: Text('Home Screen')),
    const Center(child: Text('Search Screen')),
    const MealPlannerView(), // Add the meal planner here
    const Center(child: Text('Profile Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavBar(currentIndex: _selectedIndex),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  void _onItemTapped(int index) {
    if (index == widget.currentIndex) {
      return; // Don't navigate if already on the tab
    }

    switch (index) {
      case 0:
        AppNavigator.navigateToHome(context);
        break;
      case 1:
        AppNavigator.navigateTo(context, 'search');
        break;
      case 2:
        AppNavigator.navigateToMealPlanner(context);
        break;
      case 3:
        AppNavigator.navigateToProfile(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavBar(
      selectedIndex: widget.currentIndex,
      onItemSelected: _onItemTapped,
      items: [
        NavigationItem(icon: Icons.home_rounded, label: 'Home', path: '/home'),
        NavigationItem(
          icon: Icons.search_rounded,
          label: 'Search',
          path: '/search',
        ),
        NavigationItem(
          icon: Icons.restaurant_menu_rounded,
          label: 'Meals',
          path: '/meals',
        ),
        NavigationItem(
          icon: Icons.person_rounded,
          label: 'Profile',
          path: '/profile',
        ),
      ],
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final List<NavigationItem> items;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          return _buildNavItem(
            context,
            index,
            items[index].icon,
            items[index].label,
          );
        }),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: () => onItemSelected(index),
      customBorder: const CircleBorder(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color:
                    isSelected ? Theme.of(context).primaryColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
