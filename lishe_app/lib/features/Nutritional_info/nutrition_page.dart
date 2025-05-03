import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/common/widgets/top_app_bar.dart';
import '../meal_planner/controllers/app_bar_controller.dart';
import '../meal_planner/models/app_bar_model.dart';
import '../meal_planner/models/nutrition_fact_model.dart';
import '../home/services/nutrition_facts_service.dart';
import '../home/widgets/category_filter_chip.dart';
import '../home/widgets/nutrition_fact_card.dart';

class NutritionalInfo extends StatefulWidget {
  const NutritionalInfo({super.key});

  @override
  State<NutritionalInfo> createState() => _NutritionalInfoState();
}

class _NutritionalInfoState extends State<NutritionalInfo> {
  final NutritionFactsService _service = NutritionFactsService();
  final TextEditingController _searchController = TextEditingController();
  List<NutritionFact> _nutritionFacts = [];
  bool _isLoading = true;
  List<String> _selectedCategories = [];
  String _searchQuery = '';
  final int _selectedIndex = 0;

  final List<String> _categories = [
    'All',
    'Vyakula',
    'Matunda',
    'Mbogamboga',
    'Maji',
    'Protini',
    'Vitamini',
  ];

  @override
  void initState() {
    super.initState();
    _loadNutritionFacts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  Future<void> _loadNutritionFacts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final facts = await _service.getNutritionFacts();
      setState(() {
        _nutritionFacts = facts;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load nutrition facts: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleLike(String id, bool isLiked) async {
    try {
      final updatedFact = await _service.toggleLike(id, isLiked);

      setState(() {
        final index = _nutritionFacts.indexWhere((fact) => fact.id == id);
        if (index != -1) {
          _nutritionFacts[index] = updatedFact;
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update: $e')));
      }
    }
  }

  Future<void> _toggleBookmark(String id, bool isBookmarked) async {
    try {
      final updatedFact = await _service.toggleBookmark(id, isBookmarked);

      setState(() {
        final index = _nutritionFacts.indexWhere((fact) => fact.id == id);
        if (index != -1) {
          _nutritionFacts[index] = updatedFact;
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isBookmarked
                  ? 'Added to your bookmarks'
                  : 'Removed from your bookmarks',
            ),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update: $e')));
      }
    }
  }

  void _handleCommentTap(String id) {
    // In a real app, this would navigate to a comments page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Comments feature coming soon!'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleCardTap(String id) {
    // In a real app, this would navigate to the detail page
    final fact = _nutritionFacts.firstWhere((fact) => fact.id == id);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailPlaceholderPage(fact: fact),
      ),
    );
  }

  void _handleShareTap(String id) {
    // In a real app, this would open the share sheet
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing feature coming soon!'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _filterByCategory(String category) {
    setState(() {
      if (category == 'All') {
        _selectedCategories = [];
      } else if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  List<NutritionFact> get _filteredNutritionFacts {
    List<NutritionFact> filtered = _nutritionFacts;

    // Apply category filter for multiple selections
    if (_selectedCategories.isNotEmpty) {
      filtered =
          filtered.where((fact) {
            return fact.tags.any(
              (tag) => _selectedCategories.any(
                (category) => tag.toLowerCase() == category.toLowerCase(),
              ),
            );
          }).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered.where((fact) {
            return fact.title.toLowerCase().contains(_searchQuery) ||
                fact.description.toLowerCase().contains(_searchQuery) ||
                fact.tags.any(
                  (tag) => tag.toLowerCase().contains(_searchQuery),
                );
          }).toList();
    }

    return filtered;
  }

  void _onItemTapped(int index) {
    // Navigate based on the selected index
    switch (index) {
      case 0:
        // Already on home page, no navigation needed
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/meals');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBarController = AppBarController();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Lishe',
        actions: [
          AppBarItem(
            icon: Icons.notifications_outlined,
            label: 'Notifications',
            onTap: () => appBarController.handleNotificationTap(context),
          ),
          AppBarItem(
            icon:
                Icons
                    .bookmark_border, // Changed from person_outline to bookmark_border
            label: 'Bookmarks',
            onTap: () {
              // Navigate to bookmarks
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bookmarks coming soon!'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    0,
                  ), // Increased top padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome message
                      const Text(
                        "Leo Utajifunza Nini?",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Discover nutrition facts for better health",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),

                      const SizedBox(height: 16),

                      // Search bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search nutrition facts...',
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            suffixIcon:
                                _searchQuery.isNotEmpty
                                    ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                      },
                                    )
                                    : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _CategorySliverHeaderDelegate(
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: CategoryFilterChip(
                              label: category,
                              isSelected:
                                  category == 'All'
                                      ? _selectedCategories.isEmpty
                                      : _selectedCategories.contains(category),
                              onSelected: () => _filterByCategory(category),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body:
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                    onRefresh: _loadNutritionFacts,
                    child:
                        _filteredNutritionFacts.isEmpty
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _searchQuery.isNotEmpty
                                        ? 'No results matching "$_searchQuery"'
                                        : _selectedCategories.isNotEmpty
                                        ? 'No nutrition facts in selected categories'
                                        : 'No nutrition facts found',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : ListView.builder(
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 24,
                              ),
                              itemCount: _filteredNutritionFacts.length,
                              itemBuilder: (context, index) {
                                return NutritionFactCard(
                                  fact: _filteredNutritionFacts[index],
                                  onLikeToggle: _toggleLike,
                                  onBookmarkToggle: _toggleBookmark,
                                  onCommentTap: _handleCommentTap,
                                  onCardTap: _handleCardTap,
                                  onShareTap: _handleShareTap,
                                );
                              },
                            ),
                  ),
        ),
      ),
    );
  }
}

// Placeholder detail page - in a real app this would be a proper page
class DetailPlaceholderPage extends StatelessWidget {
  final NutritionFact fact;

  const DetailPlaceholderPage({super.key, required this.fact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "",
        showBackButton: true,
        actions: [
          AppBarItem(
            icon: Icons.share,
            label: 'Share',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sharing feature coming soon!'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image with better aspect ratio
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                fact.imageUrl,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 40),
                      ),
                    ),
              ),
            ),
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
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.source, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        fact.source,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    fact.description,
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(height: 24),
                  // Tags section
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        fact.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.green.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              '#$tag',
                              style: TextStyle(
                                color: Colors.green[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
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

class _CategorySliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _CategorySliverHeaderDelegate({required this.child});

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 48.0;

  @override
  double get minExtent => 48.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

// Enhanced nutrition fact card with better image aspect ratio
class EnhancedNutritionFactCard extends StatelessWidget {
  final NutritionFact fact;
  final Function(String id, bool isLiked) onLikeToggle;
  final Function(String id, bool isBookmarked) onBookmarkToggle;
  final Function(String id) onCommentTap;
  final Function(String id) onCardTap;
  final Function(String id) onShareTap;

  const EnhancedNutritionFactCard({
    super.key,
    required this.fact,
    required this.onLikeToggle,
    required this.onBookmarkToggle,
    required this.onCommentTap,
    required this.onCardTap,
    required this.onShareTap,
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
                    errorBuilder:
                        (context, error, stackTrace) => Container(
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
                      color: Colors.black.withValues(alpha: 0.6),
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
                      onTap:
                          () => onBookmarkToggle(fact.id, !fact.isBookmarked),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          fact.isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color:
                              fact.isBookmarked
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
                      color: Colors.black.withValues(alpha: 0.7),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Tags
                  if (fact.tags.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          fact.tags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.green.withValues(alpha: .2),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                '#$tag',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  const SizedBox(height: 12),

                  // Action buttons
                  Row(
                    children: [
                      // Like button
                      _buildActionButton(
                        icon:
                            fact.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                        label: _formatNumber(fact.likeCount),
                        color: fact.isLiked ? Colors.green : Colors.grey[600]!,
                        onTap: () => onLikeToggle(fact.id, !fact.isLiked),
                      ),

                      // Comment button
                      _buildActionButton(
                        icon: Icons.chat_bubble_outline,
                        label: _formatNumber(fact.commentCount),
                        color: Colors.grey[600]!,
                        onTap: () => onCommentTap(fact.id),
                      ),

                      const Spacer(),

                      // Source label
                      Text(
                        fact.source,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Share button
                      IconButton(
                        icon: Icon(
                          Icons.ios_share, // Or alternative icon
                          size: 20,
                          color: Colors.grey[600],
                        ),
                        onPressed: () => onShareTap(fact.id),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        visualDensity: VisualDensity.compact,
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
