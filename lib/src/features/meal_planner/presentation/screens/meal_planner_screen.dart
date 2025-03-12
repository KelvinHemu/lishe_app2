import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MealPlannerScreen extends StatefulWidget {
  const MealPlannerScreen({super.key});

  @override
  State<MealPlannerScreen> createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends State<MealPlannerScreen> {
  int _selectedDay = 0;
  final List<String> _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<String> _dates = ['1', '2', '3', '4', '5', '6', '7'];

  // Sample recipe of the day data
  final Map<String, dynamic> _recipeOfDay = {
    'name': 'Quinoa Buddha Bowl',
    'chef': 'Chef Maria',
    'prepTime': '25 mins',
    'calories': 450,
    'protein': 22,
    'carbs': 65,
    'fats': 12,
    'imageUrl': 'https://picsum.photos/seed/buddha_bowl/800/600',
    'ingredients': [
      {'name': 'Quinoa', 'amount': '1 cup'},
      {'name': 'Chickpeas', 'amount': '1 can'},
      {'name': 'Avocado', 'amount': '1 medium'},
      {'name': 'Sweet Potato', 'amount': '1 large'},
    ],
    'substitutes': {
      'Quinoa': ['Brown Rice', 'Couscous', 'Bulgur'],
      'Chickpeas': ['Black Beans', 'Lentils', 'White Beans'],
      'Sweet Potato': ['Butternut Squash', 'Carrots', 'Regular Potato'],
    },
  };

  // Sample meal plan data
  final Map<String, List<Map<String, dynamic>>> _mealPlans = {
    'Mon': [
      {'type': 'Breakfast', 'name': 'Oatmeal with Fruits', 'time': '7:00 AM', 'calories': 350},
      {'type': 'Lunch', 'name': 'Grilled Chicken Salad', 'time': '12:30 PM', 'calories': 450},
      {'type': 'Dinner', 'name': 'Baked Salmon', 'time': '7:00 PM', 'calories': 550},
    ],
    'Tue': [
      {'type': 'Breakfast', 'name': 'Greek Yogurt Parfait', 'time': '7:30 AM', 'calories': 300},
      {'type': 'Lunch', 'name': 'Quinoa Bowl', 'time': '1:00 PM', 'calories': 400},
      {'type': 'Dinner', 'name': 'Vegetable Stir Fry', 'time': '6:30 PM', 'calories': 500},
    ],
  };

  // Sample AI recommendations
  final List<Map<String, dynamic>> _recommendations = [
    {
      'name': 'Mediterranean Bowl',
      'type': 'Lunch',
      'calories': 420,
      'matchScore': 95,
      'tags': ['High Protein', 'Low Carb'],
      'imageUrl': 'https://picsum.photos/seed/mediterranean/400/300',
    },
    {
      'name': 'Protein Smoothie Bowl',
      'type': 'Breakfast',
      'calories': 380,
      'matchScore': 92,
      'tags': ['High Protein', 'Vegetarian'],
      'imageUrl': 'https://picsum.photos/seed/smoothie/400/300',
    },
    {
      'name': 'Grilled Tofu Steak',
      'type': 'Dinner',
      'calories': 450,
      'matchScore': 88,
      'tags': ['Plant-based', 'High Protein'],
      'imageUrl': 'https://picsum.photos/seed/tofu/400/300',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Meal Planner',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.camera_alt_outlined, color: Colors.black87),
              onPressed: () {
                _showScanIngredientsDialog(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.calendar_month, color: Colors.black87),
              onPressed: () {
                // Show calendar view
              },
            ),
          ],
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Weekly Calendar Strip
              SliverToBoxAdapter(
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      bool isSelected = _selectedDay == index;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedDay = index),
                        child: Container(
                          width: 54,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue : Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? Colors.blue : Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _weekDays[index],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _dates[index],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Recipe of the Day
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recipe of the Day',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _RecipeOfDayCard(recipe: _recipeOfDay),
                    ],
                  ),
                ),
              ),

              // Smart Recommendations Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Smart Recommendations',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Show all recommendations
                            },
                            child: const Text('See All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          itemCount: _recommendations.length,
                          itemBuilder: (context, index) {
                            final recommendation = _recommendations[index];
                            return _RecommendationCard(
                              name: recommendation['name'],
                              type: recommendation['type'],
                              calories: recommendation['calories'],
                              matchScore: recommendation['matchScore'],
                              tags: List<String>.from(recommendation['tags']),
                              imageUrl: recommendation['imageUrl'],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Daily Meal List
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == 0) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text(
                            'Today\'s Meals',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      final mealIndex = index - 1;
                      if (mealIndex < (_mealPlans[_weekDays[_selectedDay]]?.length ?? 0)) {
                        final meal = _mealPlans[_weekDays[_selectedDay]]![mealIndex];
                        return _MealCard(
                          type: meal['type'],
                          name: meal['name'],
                          time: meal['time'],
                          calories: meal['calories'],
                        );
                      }
                      return null;
                    },
                    childCount: (_mealPlans[_weekDays[_selectedDay]]?.length ?? 0) + 1,
                  ),
                ),
              ),

              // Bottom Padding for FAB
              const SliverPadding(
                padding: EdgeInsets.only(bottom: 80),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Show meal planning dialog
          },
          backgroundColor: Colors.blue,
          icon: const Icon(Icons.add),
          label: const Text('Plan Meal'),
        ),
      ),
    );
  }

  void _showScanIngredientsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scan Ingredients'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.camera_alt,
              size: 48,
              color: Colors.blue[700],
            ),
            const SizedBox(height: 16),
            const Text(
              'Scan ingredients to get:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildScanFeature(Icons.restaurant, 'Nutritional Information'),
            _buildScanFeature(Icons.health_and_safety, 'Health Benefits'),
            _buildScanFeature(Icons.warning_amber, 'Allergen Warnings'),
            _buildScanFeature(Icons.swap_horiz, 'Ingredient Substitutes'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement camera functionality
              Navigator.pop(context);
            },
            child: const Text('Open Camera'),
          ),
        ],
      ),
    );
  }

  Widget _buildScanFeature(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue[700]),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}

class _RecipeOfDayCard extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const _RecipeOfDayCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recipe Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              recipe['imageUrl'],
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.grey,
                      size: 32,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe Title and Chef
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe['name'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'By ${recipe['chef']}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.timer, size: 16, color: Colors.blue[700]),
                          const SizedBox(width: 4),
                          Text(
                            recipe['prepTime'],
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Nutrition Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNutritionInfo('Calories', recipe['calories'], 'kcal'),
                    _buildNutritionInfo('Protein', recipe['protein'], 'g'),
                    _buildNutritionInfo('Carbs', recipe['carbs'], 'g'),
                    _buildNutritionInfo('Fats', recipe['fats'], 'g'),
                  ],
                ),
                const SizedBox(height: 16),

                // Ingredients and Substitutes
                const Text(
                  'Main Ingredients',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (recipe['ingredients'] as List).map<Widget>((ingredient) {
                    return InkWell(
                      onTap: () => _showSubstitutesDialog(context, ingredient['name'], recipe['substitutes'][ingredient['name']]),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              ingredient['name'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.swap_horiz,
                              size: 16,
                              color: Colors.blue[700],
                            ),
                          ],
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
    );
  }

  Widget _buildNutritionInfo(String label, int value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$value',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void _showSubstitutesDialog(BuildContext context, String ingredient, List<String> substitutes) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Substitutes for $ingredient'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...substitutes.map((substitute) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 20, color: Colors.green[700]),
                  const SizedBox(width: 8),
                  Text(substitute),
                ],
              ),
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final String name;
  final String type;
  final int calories;
  final int matchScore;
  final List<String> tags;
  final String imageUrl;

  const _RecommendationCard({
    required this.name,
    required this.type,
    required this.calories,
    required this.matchScore,
    required this.tags,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  imageUrl,
                  height: 90,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 90,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 90,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.grey,
                          size: 24,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$matchScore%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        type,
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.local_fire_department,
                      size: 12,
                      color: Colors.orange[700],
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '$calories',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                if (tags.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      for (final tag in tags.take(2))
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  final String type;
  final String name;
  final String time;
  final int calories;

  const _MealCard({
    required this.type,
    required this.name,
    required this.time,
    required this.calories,
  });

  IconData _getIcon(String type) {
    switch (type) {
      case 'Breakfast':
        return Icons.breakfast_dining;
      case 'Lunch':
        return Icons.lunch_dining;
      case 'Dinner':
        return Icons.dinner_dining;
      default:
        return Icons.restaurant;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getIcon(type),
                color: Colors.blue[700],
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$calories',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'kcal',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 