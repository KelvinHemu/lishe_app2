import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTabTapped;

  const BottomNavBar({
    super.key, 
    required this.currentIndex,
    this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Bottom navigation bar
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          height: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Left side navigation items
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(
                      context,
                      0,
                      Icons.home_rounded,
                      'Home',
                      '/home',
                    ),
                    _buildNavItem(
                      context,
                      1,
                      Icons.show_chart_rounded,
                      'Progress',
                      '/progress-tracker',
                    ),
                  ],
                ),
              ),
              
              // Empty space in the middle for floating camera button
              const SizedBox(width: 70),
              
              // Right side navigation items
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(
                      context,
                      2,
                      Icons.restaurant_menu_rounded,
                      'Meals',
                      '/meals',
                    ),
                    _buildNavItem(
                      context,
                      3,
                      Icons.person_rounded,
                      'Profile',
                      '/profile',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Floating camera button
        Positioned(
          bottom: 20, // Adjusted to position the camera button lower for better visibility
          child: _buildCameraButton(context),
        ),
      ],
    );
  }

  Widget _buildCameraButton(BuildContext context) {
    final isSelected = currentIndex == 4;
    
    return GestureDetector(
      onTap: () {
        // Handle camera button tap
        if (onTabTapped != null) {
          onTabTapped!(4);
        } else {
          // Navigate to camera view
          context.go('/camera');
        }
      },
      child: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white,
            width: isSelected ? 3 : 2,
          ),
        ),
        child: Icon(
          Icons.camera_alt_rounded,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
    String path,
  ) {
    final isSelected = currentIndex == index;
    return InkWell(
      onTap: () {
        // Use the callback if provided, otherwise use direct navigation
        if (onTabTapped != null) {
          onTabTapped!(index);
        } else if (currentIndex != index) {
          // Only navigate if we're not already on this tab
          context.go(path);
        }
      },
      customBorder: const CircleBorder(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
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
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 