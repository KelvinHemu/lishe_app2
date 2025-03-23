import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../models/meal.dart';

class MealMapWidget extends StatelessWidget {
  final Meal meal;

  const MealMapWidget({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                // Wrap the Text in Expanded to prevent overflow
                Expanded(
                  child: Text(
                    'Find ${meal.name} Nearby',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ), // Add some spacing between text and icon
                PhosphorIcon(
                  PhosphorIcons.mapPin(),
                  size: 25,
                  color: Colors.red.shade700,
                  weight: 200,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Nearby restaurants grid (2 columns)
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.8,
            children: [
              _buildRestaurantCard(
                'Kahawa Sukari Restaurant',
                '1.2 km',
                '4.2',
                'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500&q=80',
              ),
              _buildRestaurantCard(
                'Kahawa West Food Market',
                '2.8 km',
                '3.5',
                'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500&q=80',
              ),
              _buildRestaurantCard(
                'Thika Road Mall Food Court',
                '5.1 km',
                '4.8',
                'https://images.unsplash.com/photo-1537047902294-62a40c20a6ae?w=500&q=80',
              ),
              _buildRestaurantCard(
                'Garden City Restaurant',
                '3.4 km',
                '4.0',
                'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=500&q=80',
              ),
              _buildRestaurantCard(
                'The Local Bistro',
                '2.1 km',
                '4.5',
                'https://images.unsplash.com/photo-1544148103-0773bf10d330?w=500&q=80',
              ),
              _buildRestaurantCard(
                'Safari Grill House',
                '4.3 km',
                '4.1',
                'https://images.unsplash.com/photo-1466978913421-dad2ebd01d17?w=500&q=80',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantCard(
    String name,
    String distance,
    String rating,
    String imageUrl,
  ) {
    // Convert rating string to double for star display
    final double ratingValue = double.tryParse(rating) ?? 0.0;

    return Container(
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 115,
              width: double.infinity,
              fit: BoxFit.cover,
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
                  message: name, // Show full name on long press
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 5),

                // Distance - centered with increased font size
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
                        distance,
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

                // Rating as stars - larger and without numerical rating
                Center(
                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min, // Prevent row from taking full width
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < ratingValue.floor()
                              ? Icons.star
                              : (index < ratingValue)
                              ? Icons.star_half
                              : Icons.star_border,
                          size: 20, // Increased size from 14 to 16
                          color: Colors.amber.shade700,
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
