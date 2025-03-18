import 'package:flutter/material.dart';

class FoodPictureWidget extends StatelessWidget {
  final String imageUrl;
  final double size;

  const FoodPictureWidget({
    super.key,
    required this.imageUrl,
    this.size = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.3,
            ), // Fixed from withValues to withOpacity
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: size,
          height: size,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                strokeWidth: 2.0,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Error loading image: $imageUrl - $error');
            return Container(
              color: Colors.grey[200],
              child: const Icon(Icons.broken_image, color: Colors.grey),
            );
          },
        ),
      ),
    );
  }
}
