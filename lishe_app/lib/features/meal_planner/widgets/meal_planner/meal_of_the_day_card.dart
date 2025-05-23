import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/meal.dart';
import '../../providers/rating_provider.dart';
import '../../../../core/common/widgets/rating_stars_widget.dart';

class MealOfTheDayCard extends ConsumerWidget {
  final Meal? meal;
  final VoidCallback? onTap;
  final bool showHeader;
  final String? mealType;

  const MealOfTheDayCard({
    super.key,
    required this.meal,
    this.onTap,
    this.showHeader = true,
    this.mealType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current rating for this meal
    final double rating =
        meal != null ? ref.watch(mealRatingProvider(meal!.id)) : 0.0;

    // Process meal name to remove meal type if present
    String displayName = '';
    if (meal != null) {
      // Remove any meal type from the name
      displayName =
          meal!.name
              .replaceAll(
                RegExp(r'\b(breakfast|lunch|dinner)\b', caseSensitive: false),
                '',
              )
              .trim();

      // Clean up any artifacts like extra spaces or dashes
      displayName = displayName.replaceAll(RegExp(r'\s+-\s*'), '').trim();

      // If name became empty after removal, use original name
      if (displayName.isEmpty) {
        displayName = meal!.name;
      }
    } else {
      displayName = 'Featured Meal';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row - only show if showHeader is true
        if (showHeader)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (mealType != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade700,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              mealType!.capitalize(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          displayName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Add rating stars widget
                  if (meal != null)
                    RatingStarsWidget(
                      rating: rating > 0 ? rating : 0.0,
                      size: 25,
                      isInteractive: true,
                      onRatingChanged: (newRating) {
                        ref
                            .read(ratingProvider.notifier)
                            .setMealRating(meal!.id, newRating);
                      },
                    ),
                ],
              ),
            ),
          ),

        // Existing card content
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ), // Reduced from vertical: 12 to 6
          height: 350, // Increased height for better visual impact
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Fixed from withValues
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
                        colors: [
                          Colors.black.withOpacity(
                            0.7,
                          ), // Fixed from withValues
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  // Keep the original positioned meal name only if not showing header
                  if (!showHeader)
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
                            shadows: [
                              Shadow(color: Colors.black54, blurRadius: 4),
                            ],
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
        ),
      ],
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

// Add this extension at the end of the file
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
