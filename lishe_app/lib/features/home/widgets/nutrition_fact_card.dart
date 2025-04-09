import 'package:flutter/material.dart';
import '../../meal_planner/models/nutrition_fact_model.dart';
import 'nutritionist_info_widget.dart';

class NutritionFactCard extends StatelessWidget {
  final NutritionFact fact;
  final Function(String id, bool isLiked) onLikeToggle;
  final Function(String id, bool isBookmarked) onBookmarkToggle;
  final Function(String id) onCommentTap;
  final Function(String id) onCardTap;
  final Function(String id) onShareTap;
  final Function(String id)? onNutritionistTap;

  const NutritionFactCard({
    super.key,
    required this.fact,
    required this.onLikeToggle,
    required this.onBookmarkToggle,
    required this.onCommentTap,
    required this.onCardTap,
    required this.onShareTap,
    this.onNutritionistTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onCardTap(fact.id),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        clipBehavior: Clip.antiAlias,
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with better aspect ratio
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 10, // Better aspect ratio for images
                  child: Image.network(
                    fact.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 40),
                      ),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
                ),
                // Source badge
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: fact.nutritionist?.accentColor ?? Colors.blue,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Expert",
                          style: TextStyle(
                            color: fact.nutritionist?.accentColor ??
                                Colors.blue[800],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // View count badge
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.visibility,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatNumber(fact.viewCount),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Bookmark button
                Positioned(
                  top: 10,
                  left: 10,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () =>
                          onBookmarkToggle(fact.id, !fact.isBookmarked),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          fact.isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: fact.isBookmarked
                              ? Colors.green
                              : Colors.grey[600],
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nutritionist info (if available)
                  if (fact.nutritionist != null) ...[
                    NutritionistInfoWidget(
                      nutritionist: fact.nutritionist!,
                      onTap: onNutritionistTap != null
                          ? () => onNutritionistTap!(fact.nutritionist!.id)
                          : null,
                      isCompact: true,
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Title
                  Text(
                    fact.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    fact.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Colors.black.withOpacity(0.7),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),

                  // Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: fact.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '#$tag',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[800],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // Interaction buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Like button
                          _buildInteractionButton(
                            icon: fact.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            count: fact.likeCount,
                            color: fact.isLiked ? Colors.red : null,
                            onTap: () => onLikeToggle(fact.id, !fact.isLiked),
                          ),
                          const SizedBox(width: 16),
                          // Comment button
                          _buildInteractionButton(
                            icon: Icons.chat_bubble_outline,
                            count: fact.commentCount,
                            onTap: () => onCommentTap(fact.id),
                          ),
                        ],
                      ),
                      // Share button
                      _buildInteractionButton(
                        icon: Icons.share_outlined,
                        onTap: () => onShareTap(fact.id),
                        showCount: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionButton({
    required IconData icon,
    int? count,
    Color? color,
    bool showCount = true,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: color ?? Colors.grey[600],
            ),
            if (showCount && count != null) ...[
              const SizedBox(width: 4),
              Text(
                _formatNumber(count),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color ?? Colors.grey[700],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }
}

class DetailPlaceholderPage extends StatelessWidget {
  final NutritionFact fact;

  const DetailPlaceholderPage({
    super.key,
    required this.fact,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fact.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            SizedBox(
              width: double.infinity,
              height: 250,
              child: Image.network(
                fact.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 60),
                    ),
                  );
                },
              ),
            ),

            // Nutritionist info (if available)
            if (fact.nutritionist != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: NutritionistInfoWidget(
                  nutritionist: fact.nutritionist!,
                  isCompact: false,
                ),
              ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fact.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    fact.description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'This is a placeholder for detailed content about ${fact.title}. In a real app, this would include more detailed information, related nutrition facts, and recommendations.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
