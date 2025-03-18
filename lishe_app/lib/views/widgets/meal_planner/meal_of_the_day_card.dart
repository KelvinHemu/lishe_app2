import 'package:flutter/material.dart';
import '../../../models/meal.dart';

class MealOfTheDayCard extends StatelessWidget {
  final Meal? meal;
  final VoidCallback? onTap;

  const MealOfTheDayCard({super.key, required this.meal, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 350, // Increased height for better visual impact
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildMealImage(),
              ),

              // Gradient overlay for better text visibility
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.center,
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  ),
                ),
              ),

              // Meal name
              Positioned(
                top: 20,
                left: 20,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    meal?.name ?? 'No meal planned',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealImage() {
    // Check if meal exists and has an image URL
    if (meal == null || meal!.imageUrl.isEmpty) {
      return _buildPlaceholderImage();
    }

    // Check if the image URL is a network image or asset image
    final bool isNetworkImage = meal!.imageUrl.startsWith('http');

    if (isNetworkImage) {
      // Handle network images
      return Image.network(
        meal!.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey.shade200,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      );
    } else {
      // Handle asset images
      return Image.asset(
        meal!.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
      );
    }
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey.shade300,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant, size: 80, color: Colors.grey),
            SizedBox(height: 8),
            Text("No meal image", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
