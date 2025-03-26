import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBarController {
  void handleNotificationTap(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notifications coming soon!'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void handleProfileTap(BuildContext context) {
    context.go('/profile');
  }
}
