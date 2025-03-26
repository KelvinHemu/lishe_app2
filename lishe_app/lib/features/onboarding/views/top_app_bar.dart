import 'package:flutter/material.dart';
import '../../meal_planner/models/app_bar_model.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<AppBarItem>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading:
          showBackButton
              ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: onBackPressed ?? () => Navigator.pop(context),
              )
              : null,
      title: Row(
        children: [
          SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(193, 15, 65, 9),
              fontSize: 28,
            ),
          ),
        ],
      ),
      actions:
          actions
              ?.map(
                (item) => IconButton(
                  icon: Icon(item.icon, color: Colors.black87),
                  tooltip: item.label,
                  onPressed: item.onTap,
                ),
              )
              .toList(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
