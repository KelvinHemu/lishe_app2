import 'package:flutter/material.dart';

class MealActionButtons extends StatelessWidget {
  const MealActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // View meal details
          },
          icon: const Icon(Icons.restaurant_menu),
          label: const Text('View Details'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue.shade700,
          ),
        ),
        const SizedBox(width: 10),
        OutlinedButton(
          onPressed: () {
            // Mark as eaten
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,
            side: const BorderSide(color: Colors.white),
            foregroundColor: Colors.white,
          ),
          child: const Text('Mark as Eaten'),
        ),
      ],
    );
  }
}
