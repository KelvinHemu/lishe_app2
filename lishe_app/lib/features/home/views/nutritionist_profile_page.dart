import 'package:flutter/material.dart';
import '../models/nutritionist_model.dart';
import '../services/nutrition_facts_service.dart';
import '../../meal_planner/models/nutrition_fact_model.dart';
import '../widgets/nutrition_fact_card.dart';
import 'home_page.dart' as home;

class NutritionistProfilePage extends StatefulWidget {
  final Nutritionist nutritionist;

  const NutritionistProfilePage({
    Key? key,
    required this.nutritionist,
  }) : super(key: key);

  @override
  State<NutritionistProfilePage> createState() =>
      _NutritionistProfilePageState();
}

class _NutritionistProfilePageState extends State<NutritionistProfilePage> {
  final NutritionFactsService _service = NutritionFactsService();
  List<NutritionFact>? _nutritionFacts;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNutritionFacts();
  }

  Future<void> _loadNutritionFacts() async {
    setState(() => _isLoading = true);
    try {
      final facts = await _service
          .getNutritionFactsByNutritionist(widget.nutritionist.id);
      setState(() {
        _nutritionFacts = facts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _nutritionFacts = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building NutritionistProfilePage for ${widget.nutritionist.name}');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Nutritionist Image and Name
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.nutritionist.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: Color.fromARGB(150, 0, 0, 0),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.nutritionist.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                          color:
                              widget.nutritionist.accentColor.withOpacity(0.3));
                    },
                  ),
                  // Gradient overlay for better text visibility
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black54,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Profile Information
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Verification Badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.nutritionist.title,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: widget.nutritionist.accentColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      if (widget.nutritionist.isVerified)
                        Tooltip(
                          message: 'Verified Nutritionist',
                          child: Icon(
                            Icons.verified,
                            color: widget.nutritionist.accentColor,
                            size: 24,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Location Information
                  if (widget.nutritionist.location.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 20,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.nutritionist.location,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Bio
                  Text(
                    widget.nutritionist.bio,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Stats Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(
                        icon: Icons.article,
                        label: 'Articles',
                        value: _nutritionFacts?.length.toString() ?? '0',
                        color: widget.nutritionist.accentColor,
                      ),
                      _buildStatItem(
                        icon: Icons.remove_red_eye,
                        label: 'Views',
                        value: _calculateTotalViews(),
                        color: widget.nutritionist.accentColor,
                      ),
                      _buildStatItem(
                        icon: Icons.thumb_up,
                        label: 'Likes',
                        value: _calculateTotalLikes(),
                        color: widget.nutritionist.accentColor,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Experience and Education
                  _buildInfoSection(
                    title: 'Experience & Education',
                    children: [
                      if (widget.nutritionist.experienceYears != null)
                        _buildInfoItem(
                          Icons.work,
                          '${widget.nutritionist.experienceYears} years of experience',
                        ),
                      if (widget.nutritionist.educationBackground != null)
                        _buildInfoItem(
                          Icons.school,
                          widget.nutritionist.educationBackground!,
                        ),
                    ],
                  ),

                  // Specializations
                  if (widget.nutritionist.specializations != null &&
                      widget.nutritionist.specializations!.isNotEmpty)
                    _buildSpecializationsSection(),

                  // Languages
                  if (widget.nutritionist.languages != null &&
                      widget.nutritionist.languages!.isNotEmpty)
                    _buildInfoSection(
                      title: 'Languages',
                      children: [
                        Wrap(
                          spacing: 8,
                          children: widget.nutritionist.languages!
                              .map((language) => Chip(
                                    label: Text(language),
                                    backgroundColor: widget
                                        .nutritionist.accentColor
                                        .withOpacity(0.1),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),

                  // Contact Information
                  _buildContactSection(),

                  // Location Map
                  if (widget.nutritionist.location.isNotEmpty)
                    _buildLocationSection(),

                  // Social Media
                  if (widget.nutritionist.socialMedia != null &&
                      widget.nutritionist.socialMedia!.isNotEmpty)
                    _buildSocialMediaSection(),

                  const SizedBox(height: 24),

                  // Published Nutrition Facts
                  Text(
                    'Published Nutrition Facts',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // Nutrition Facts List
          _isLoading
              ? const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : _nutritionFacts != null && _nutritionFacts!.isNotEmpty
                  ? SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final fact = _nutritionFacts![index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: NutritionFactCard(
                                fact: fact,
                                onLikeToggle: (id, isLiked) {
                                  print('Like toggled: $id, $isLiked');
                                  // This could be implemented to update like state
                                },
                                onBookmarkToggle: (id, isBookmarked) {
                                  print('Bookmark toggled: $id, $isBookmarked');
                                  // This could be implemented to update bookmark state
                                },
                                onCommentTap: (id) {
                                  print('Comment tapped: $id');
                                  // Navigate to comments page
                                },
                                onCardTap: (id) {
                                  print('Card tapped: $id');
                                  // Navigate to detail page
                                  final tappedFact = _nutritionFacts!
                                      .firstWhere((f) => f.id == id);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          home.DetailPlaceholderPage(
                                              fact: tappedFact),
                                    ),
                                  );
                                },
                                onShareTap: (id) {
                                  print('Share tapped: $id');
                                  // Share functionality
                                },
                                onNutritionistTap: (id) {
                                  print(
                                      'Nutritionist tapped: $id (already on profile page)');
                                  // Already on nutritionist profile, no need to navigate
                                },
                              ),
                            );
                          },
                          childCount: _nutritionFacts!.length,
                        ),
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            'No nutrition facts published yet',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecializationsSection() {
    return _buildInfoSection(
      title: 'Specializations',
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.nutritionist.specializations!.map((specialization) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: widget.nutritionist.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.nutritionist.accentColor.withOpacity(0.3),
                ),
              ),
              child: Text(
                specialization,
                style: TextStyle(
                  color: widget.nutritionist.accentColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    List<Widget> contactItems = [];

    if (widget.nutritionist.email != null) {
      contactItems.add(_buildInfoItem(Icons.email, widget.nutritionist.email!));
    }

    if (widget.nutritionist.phone != null) {
      contactItems.add(_buildInfoItem(Icons.phone, widget.nutritionist.phone!));
    }

    if (widget.nutritionist.website != null) {
      contactItems
          .add(_buildInfoItem(Icons.language, widget.nutritionist.website!));
    }

    if (contactItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildInfoSection(
      title: 'Contact Information',
      children: contactItems,
    );
  }

  Widget _buildSocialMediaSection() {
    final socialIcons = {
      'facebook': Icons.facebook,
      'twitter': Icons.tag,
      'instagram': Icons.camera_alt_outlined,
      'linkedin': Icons.connect_without_contact,
      'researchgate': Icons.science_outlined,
    };

    return _buildInfoSection(
      title: 'Social Media',
      children: [
        Wrap(
          spacing: 16,
          children: widget.nutritionist.socialMedia!.entries.map((entry) {
            final platform = entry.key.toLowerCase();
            final handle = entry.value;

            return Chip(
              avatar: Icon(
                socialIcons[platform] ?? Icons.link,
                size: 18,
                color: widget.nutritionist.accentColor,
              ),
              label: Text(handle),
              backgroundColor: Colors.grey[200],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return _buildInfoSection(
      title: 'Location',
      children: [
        Container(
          height: 200,
          width: double.infinity,
          margin: const EdgeInsets.only(top: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // In a real app, this would be a Google Map or other map widget
                // For now, we'll use a placeholder
                Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map,
                          size: 48,
                          color: widget.nutritionist.accentColor,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Map for ${widget.nutritionist.location}',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap to view on Google Maps',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Make it tappable to open maps app
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      // In a real app, open maps app or web maps
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Opening maps app...'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.location_on,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                widget.nutritionist.location,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                // In a real app, open maps app
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening directions...'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              icon: Icon(
                Icons.directions,
                color: widget.nutritionist.accentColor,
                size: 16,
              ),
              label: Text(
                'Get Directions',
                style: TextStyle(
                  color: widget.nutritionist.accentColor,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 24,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
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
    );
  }

  String _calculateTotalViews() {
    if (_nutritionFacts == null || _nutritionFacts!.isEmpty) {
      return '0';
    }
    final total = _nutritionFacts!.fold<int>(
      0,
      (sum, fact) => sum + fact.viewCount,
    );
    return _formatNumber(total);
  }

  String _calculateTotalLikes() {
    if (_nutritionFacts == null || _nutritionFacts!.isEmpty) {
      return '0';
    }
    final total = _nutritionFacts!.fold<int>(
      0,
      (sum, fact) => sum + fact.likeCount,
    );
    return _formatNumber(total);
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
