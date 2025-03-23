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
          Row(
            children: [
              PhosphorIcon(
                PhosphorIcons.mapPin(),
                size: 20,
                color: Colors.red.shade700,
              ),
              const SizedBox(width: 8),
              Text(
                'Find ${meal.name} Nearby',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Placeholder for the map
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PhosphorIcon(
                    PhosphorIcons.mapTrifold(),
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  const Text('Map will be displayed here'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Sample nearby places (to be replaced with real data later)
          Text(
            'Nearby Places for ${meal.name}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Sample places list
          _buildNearbyPlaceItem(
            'Kahawa Sukari Restaurant',
            '1.2 km away',
            '⭐⭐⭐⭐ 4.2',
          ),
          _buildNearbyPlaceItem(
            'Kahawa West Food Market',
            '2.8 km away',
            '⭐⭐⭐ 3.5',
          ),
          _buildNearbyPlaceItem(
            'Thika Road Mall Food Court',
            '5.1 km away',
            '⭐⭐⭐⭐⭐ 4.8',
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyPlaceItem(String name, String distance, String rating) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: PhosphorIcon(
                PhosphorIcons.storefront(),
                size: 24,
                color: Colors.red.shade700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  distance,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            rating,
            style: TextStyle(
              color: Colors.amber.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
