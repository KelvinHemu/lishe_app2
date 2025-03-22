import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RandomRecipeWidget extends StatefulWidget {
  final VoidCallback onRandomPressed;
  final VoidCallback onExplorePressed;

  const RandomRecipeWidget({
    super.key,
    required this.onRandomPressed,
    required this.onExplorePressed,
  });

  @override
  State<RandomRecipeWidget> createState() => _RandomRecipeWidgetState();
}

class _RandomRecipeWidgetState extends State<RandomRecipeWidget> {
  bool isRolling = false;

  void _handleRoll() {
    setState(() {
      isRolling = true;
    });
    widget.onRandomPressed();
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          isRolling = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Dice icon with background
          InkWell(
            onTap: _handleRoll,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.casino, color: Colors.green, size: 28)
                  .animate(onPlay: (controller) => controller.repeat())
                  .then(delay: 1.seconds)
                  .rotate(duration: 1.seconds, end: isRolling ? 360 : 0)
                  .scale(
                    duration: 800.ms,
                    begin: const Offset(1, 1),
                    end: const Offset(1.1, 1.1),
                  )
                  .then()
                  .scale(
                    duration: 800.ms,
                    begin: const Offset(1.1, 1.1),
                    end: const Offset(1, 1),
                  ),
            ),
          ),
          Text(
            'Other Meals',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
          // Explore icon with background
          InkWell(
            onTap: widget.onExplorePressed,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.explore, color: Colors.green, size: 28)
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(
                    duration: 1.seconds,
                    begin: const Offset(1, 1),
                    end: const Offset(1.15, 1.15),
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .scale(
                    duration: 1.seconds,
                    begin: const Offset(1.15, 1.15),
                    end: const Offset(1, 1),
                    curve: Curves.easeInOut,
                  )
                  .shimmer(duration: 1.seconds, color: Colors.green.shade200),
            ),
          ),
        ],
      ),
    );
  }
}
