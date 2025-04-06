import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common/widgets/top_app_bar.dart';
import '../controllers/app_bar_controller.dart';
import '../models/app_bar_model.dart';

class NutritionInfoPage extends StatefulWidget {
  final String factId;

  const NutritionInfoPage({super.key, required this.factId});

  @override
  State<NutritionInfoPage> createState() => _NutritionInfoPageState();
}

class _NutritionInfoPageState extends State<NutritionInfoPage> {
  final int _selectedIndex = 0; // Default to home tab

  void _onItemTapped(int index) {
    // Navigate based on index
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/meals');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBarController = AppBarController();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Nutrition Info',
        showBackButton: true,
        onBackPressed: () => context.go('/home'),
        actions: [
          AppBarItem(
            icon: Icons.notifications_outlined,
            label: 'Notifications',
            onTap: () => appBarController.handleNotificationTap(context),
          ),
          AppBarItem(
            icon: Icons.person_outline,
            label: 'Profile',
            onTap: () => appBarController.handleProfileTap(context),
          ),
        ],
      ),
      body: Center(
        child: Text('Nutrition information for ID: ${widget.factId}'),
      ),
    );
  }
}
