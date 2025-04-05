import 'package:flutter/material.dart';

class UiConstants {
  // Padding
  static const EdgeInsets paddingAll8 = EdgeInsets.all(8.0);
  static const EdgeInsets paddingAll16 = EdgeInsets.all(16.0);
  static const EdgeInsets paddingHorizontal16 = EdgeInsets.symmetric(
    horizontal: 16.0,
  );
  static const EdgeInsets paddingVertical8 = EdgeInsets.symmetric(
    vertical: 8.0,
  );
  static const EdgeInsets paddingVertical16 = EdgeInsets.symmetric(
    vertical: 16.0,
  );

  // Spacing widgets
  static const SizedBox gapH8 = SizedBox(height: 8);
  static const SizedBox gapH16 = SizedBox(height: 16);
  static const SizedBox gapH24 = SizedBox(height: 24);
  static const SizedBox gapW8 = SizedBox(width: 8);
  static const SizedBox gapW16 = SizedBox(width: 16);

  // Box decorations
  static BoxDecoration roundedContainerDecoration(
    BuildContext context, {
    double radius = 12.0,
  }) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static BoxDecoration fadeContainerDecoration(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Theme.of(context).colorScheme.primary.withOpacity(0.1),
          Colors.transparent,
        ],
      ),
      borderRadius: BorderRadius.circular(12),
    );
  }
}
