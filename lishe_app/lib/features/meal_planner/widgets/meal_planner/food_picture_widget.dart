import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          width: size,
          height: size,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          ),
          errorWidget: (context, url, error) {
            debugPrint('Error loading image: $url - $error');
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
