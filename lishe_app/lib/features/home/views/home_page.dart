import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/nutrition_facts_service.dart';
import '../../meal_planner/models/nutrition_fact_model.dart';
import '../widgets/nutrition_fact_card.dart';
import '../widgets/category_filter_chip.dart';
import '../../../core/common/widgets/bottom_nav_bar.dart';
import '../../../core/common/models/navigation_model.dart';
import '../models/nutritionist_model.dart';
import 'nutritionist_profile_simplified.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NutritionFactsService _service = NutritionFactsService();
  final TextEditingController _searchController = TextEditingController();
  List<NutritionFact> _nutritionFacts = [];
  List<Nutritionist> _nutritionists = [];
  bool _isLoading = true;
  List<String> _selectedCategories = [];
  String? _selectedNutritionistId;
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
    _loadData();
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

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load nutritionists first
      final nutritionists = await _service.getNutritionists();

      // Then load nutrition facts
      final facts = await _service.getNutritionFacts();

      setState(() {
        _nutritionists = nutritionists;
        _nutritionFacts = facts;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load data: $e')),
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

  void _handleNutritionistTap(String nutritionistId) {
    // Get the nutritionist by ID
    print('Tapped on nutritionist with ID: $nutritionistId');

    final nutritionist = _nutritionists.firstWhere(
      (nutritionist) => nutritionist.id == nutritionistId,
      orElse: () => _nutritionists.first,
    );

    print('Found nutritionist: ${nutritionist.name}');

    // Navigate to the nutritionist profile page
    print('Attempting to navigate to NutritionistProfileSimplified');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            NutritionistProfileSimplified(nutritionist: nutritionist),
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

    // Apply nutritionist filter
    if (_selectedNutritionistId != null) {
      filtered = filtered
          .where((fact) =>
              fact.nutritionist != null &&
              fact.nutritionist!.id == _selectedNutritionistId)
          .toList();
    }

    // Apply category filter for multiple selections
    if (_selectedCategories.isNotEmpty) {
      filtered = filtered.where((fact) {
        return fact.tags.any(
          (tag) => _selectedCategories.any(
            (category) => tag.toLowerCase() == category.toLowerCase(),
          ),
        );
      }).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((fact) {
        return fact.title.toLowerCase().contains(_searchQuery) ||
            fact.description.toLowerCase().contains(_searchQuery) ||
            fact.tags.any((tag) => tag.toLowerCase().contains(_searchQuery));
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width to adjust the UI for web
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 800;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Lishe App'),
        actions: [
          // Direct access to nutritionist profiles
          IconButton(
            icon: const Icon(Icons.person_search),
            tooltip: 'Nutritionist Profiles',
            onPressed: () {
              if (_nutritionists.isNotEmpty) {
                print('Accessing nutritionist profile directly');
                final nutritionist = _nutritionists.first;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NutritionistProfileSimplified(
                        nutritionist: nutritionist),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Handle notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              // Handle bookmarks
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Tafuta habari za lishe...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 20,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                    ),
                  ),
                ),

                // Nutritionists horizontal list
                Container(
                  height: 120,
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Wataalamu wa Lishe',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Experts',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _nutritionists.length,
                          itemBuilder: (context, index) {
                            final nutritionist = _nutritionists[index];
                            final isSelected =
                                _selectedNutritionistId == nutritionist.id;
                            final articleCounts = _getArticleCounts();
                            final articleCount =
                                articleCounts[nutritionist.id] ?? 0;

                            return Container(
                              margin: const EdgeInsets.only(right: 16),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    print(
                                        'Tapping nutritionist from list: ${nutritionist.name}');
                                    _handleNutritionistTap(nutritionist.id);
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? nutritionist.accentColor
                                              .withOpacity(0.1)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? nutritionist.accentColor
                                            : Colors.grey.withOpacity(0.2),
                                        width: 1.5,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 4),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Stack(
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: isSelected
                                                      ? nutritionist.accentColor
                                                      : Colors.transparent,
                                                  width: 2,
                                                ),
                                              ),
                                              child: CircleAvatar(
                                                radius: 32,
                                                backgroundImage: NetworkImage(
                                                    nutritionist.imageUrl),
                                                backgroundColor:
                                                    Colors.grey[200],
                                              ),
                                            ),
                                            if (nutritionist.isVerified)
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      blurRadius: 4,
                                                      offset:
                                                          const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Icon(
                                                  Icons.verified,
                                                  color:
                                                      nutritionist.accentColor,
                                                  size: 16,
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          nutritionist.name.split(' ')[0],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? nutritionist.accentColor
                                                : Colors.black87,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              _getSpecialty(nutritionist.title),
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey[700],
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(width: 4),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                      vertical: 1),
                                              decoration: BoxDecoration(
                                                color: nutritionist.accentColor
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                '$articleCount',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      nutritionist.accentColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Category filter chips
                Container(
                  height: 50,
                  padding: const EdgeInsets.only(left: 16),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = category == 'All'
                          ? _selectedCategories.isEmpty
                          : _selectedCategories.contains(category);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CategoryFilterChip(
                          label: category,
                          isSelected: isSelected,
                          onSelected: () => _filterByCategory(category),
                        ),
                      );
                    },
                  ),
                ),

                // Content - responsive layout for web
                Expanded(
                  child: _filteredNutritionFacts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Hakuna matokeo',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                'Jaribu utafutaji tofauti',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : isWeb
                          // Web layout - grid view
                          ? GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: screenWidth > 1200 ? 3 : 2,
                                childAspectRatio: 0.8,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemCount: _filteredNutritionFacts.length,
                              itemBuilder: (context, index) {
                                final fact = _filteredNutritionFacts[index];
                                return NutritionFactCard(
                                  fact: fact,
                                  onLikeToggle: _toggleLike,
                                  onBookmarkToggle: _toggleBookmark,
                                  onCommentTap: _handleCommentTap,
                                  onCardTap: _handleCardTap,
                                  onShareTap: _handleShareTap,
                                  onNutritionistTap: _handleNutritionistTap,
                                );
                              },
                            )
                          // Mobile layout - list view
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemCount: _filteredNutritionFacts.length,
                              itemBuilder: (context, index) {
                                final fact = _filteredNutritionFacts[index];
                                return NutritionFactCard(
                                  fact: fact,
                                  onLikeToggle: _toggleLike,
                                  onBookmarkToggle: _toggleBookmark,
                                  onCommentTap: _handleCommentTap,
                                  onCardTap: _handleCardTap,
                                  onShareTap: _handleShareTap,
                                  onNutritionistTap: _handleNutritionistTap,
                                );
                              },
                            ),
                ),
              ],
            ),
      // Add floating action button to access nutritionist profile
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_nutritionists.isNotEmpty) {
            print('Accessing nutritionist profile from FAB');
            final nutritionist = _nutritionists.first;
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 500),
                pageBuilder: (_, __, ___) => NutritionistProfileSimplified(
                  nutritionist: nutritionist,
                ),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          }
        },
        backgroundColor: Colors.green,
        label: const Text('Nutritionist Profiles'),
        icon: const Icon(Icons.person_search),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          switch (index) {
            case 0:
              // Already on home
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
        },
        items: const [
          NavigationItem(
            icon: Icons.home_rounded,
            label: 'Home',
            path: '/home',
          ),
          NavigationItem(
            icon: Icons.search_rounded,
            label: 'Search',
            path: '/search',
          ),
          NavigationItem(
            icon: Icons.restaurant_menu_rounded,
            label: 'Meals',
            path: '/meals',
          ),
          NavigationItem(
            icon: Icons.person_rounded,
            label: 'Profile',
            path: '/profile',
          ),
        ],
      ),
    );
  }

  // Helper method to extract a short specialty from the nutritionist title
  String _getSpecialty(String title) {
    final specialties = {
      'Clinical': 'Clinical',
      'Sports': 'Sports',
      'Pediatric': 'Pediatric',
      'Public Health': 'Public Health',
      'Dietitian': 'Diet',
      'Nutrition': 'Nutrition',
    };

    for (final specialty in specialties.keys) {
      if (title.contains(specialty)) {
        return specialties[specialty]!;
      }
    }

    // Default if no known specialty is found
    return title.split(' ').first;
  }

  // Count how many articles each nutritionist has published
  Map<String, int> _getArticleCounts() {
    final Map<String, int> counts = {};

    for (final fact in _nutritionFacts) {
      if (fact.nutritionist != null) {
        final id = fact.nutritionist!.id;
        counts[id] = (counts[id] ?? 0) + 1;
      }
    }

    return counts;
  }
}

// Detail page placeholder
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
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
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
              _buildNutritionistSection(context, fact.nutritionist!),

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
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: fact.nutritionist?.accentColor ?? Colors.blue,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Source: Expert',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${fact.publishedDate.day}/${fact.publishedDate.month}/${fact.publishedDate.year}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
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

                  // Tags
                  if (fact.tags.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: fact.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.green.withOpacity(0.3),
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

  Widget _buildNutritionistSection(
      BuildContext context, Nutritionist nutritionist) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                NutritionistProfileSimplified(nutritionist: nutritionist),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: nutritionist.accentColor.withOpacity(0.05),
          border: Border(
            top: BorderSide(
              color: nutritionist.accentColor.withOpacity(0.2),
              width: 1,
            ),
            bottom: BorderSide(
              color: nutritionist.accentColor.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(nutritionist.imageUrl),
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            nutritionist.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (nutritionist.isVerified) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.verified,
                              size: 16,
                              color: nutritionist.accentColor,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        nutritionist.title,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: nutritionist.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: nutritionist.accentColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View Profile',
                        style: TextStyle(
                          color: nutritionist.accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        size: 12,
                        color: nutritionist.accentColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'About',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: nutritionist.accentColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              nutritionist.bio,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (nutritionist.location.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    nutritionist.location,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatCard(
                  icon: Icons.article_outlined,
                  label: 'Articles',
                  value: '23',
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  icon: Icons.people_outline,
                  label: 'Followers',
                  value: '1.2K',
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  icon: Icons.thumb_up_outlined,
                  label: 'Likes',
                  value: '4.5K',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: Colors.grey[700]),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
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
                      children: fact.tags.map((tag) {
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
                        icon: fact.isLiked
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
