import 'package:flutter/material.dart';
import '../../models/restaurant.dart';
import '../../../../core/common/widgets/star_rating_widget.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback? onTap;

  const RestaurantCard({super.key, required this.restaurant, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                restaurant.imageUrl,
                height: 115,
                width: double.infinity,
                fit: BoxFit.cover,
                cacheWidth: 300, // Specify a size for memory optimization
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    height: 115,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 115,
                      color: Colors.grey[300],
                      child: const Icon(Icons.restaurant, color: Colors.grey),
                    ),
              ),
            ),

            // Restaurant details
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant name with ellipsis
                  Tooltip(
                    message: restaurant.name,
                    child: Text(
                      restaurant.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Distance - centered
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 2),
                        Text(
                          restaurant.distance,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Rating as stars
                  Center(child: StarRating(rating: restaurant.rating)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
