import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../models/restaurant.dart';
import '../models/meal.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final Restaurant restaurant;
  final Meal currentMeal;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurant,
    required this.currentMeal,
  });

  @override
  Widget build(BuildContext context) {
    // Mock data for other meals at this restaurant
    final otherMeals = [
      Meal(
        id: 'rest-meal-1',
        name: 'Chicken Biriyani',
        calories: 450,
        protein: 35.0,
        carbs: 60.0,
        fat: 15.0,
        imageUrl:
            'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=500&q=80',
        difficulty: 'Medium',
      ),
      Meal(
        id: 'rest-meal-2',
        name: 'Fish Curry',
        calories: 320,
        protein: 28.0,
        carbs: 22.0,
        fat: 18.0,
        imageUrl:
            'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=500&q=80',
        difficulty: 'Easy',
      ),
      Meal(
        id: 'rest-meal-3',
        name: currentMeal.name,
        calories: currentMeal.calories,
        protein: currentMeal.protein,
        carbs: currentMeal.carbs,
        fat: currentMeal.fat,
        imageUrl: currentMeal.imageUrl,
        difficulty: currentMeal.difficulty,
      ),
      Meal(
        id: 'rest-meal-4',
        name: 'Vegetable Pilau',
        calories: 380,
        protein: 12.0,
        carbs: 65.0,
        fat: 10.0,
        imageUrl:
            'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=500&q=80',
        difficulty: 'Medium',
      ),
    ];

    // Mock cuisine types for restaurant
    final cuisineTypes =
        restaurant.cuisineTypes ?? ['Local', 'Continental', 'Seafood'];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Restaurant image header with back button
          SliverAppBar(
            expandedHeight: 220.0,
            floating: false,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Restaurant image
                  Image.network(restaurant.imageUrl, fit: BoxFit.cover),
                  // Gradient overlay for better text visibility
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Restaurant information and content
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Restaurant name below the image
                    Text(
                      restaurant.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Restaurant info
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < restaurant.rating.floor()
                                  ? Icons.star
                                  : (index < restaurant.rating)
                                  ? Icons.star_half
                                  : Icons.star_border,
                              color: Colors.amber.shade700,
                              size: 20,
                            );
                          }),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${restaurant.rating})',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.location_on,
                          color: Colors.red.shade700,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          restaurant.distance,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        // Call button (small)
                        IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Calling restaurant'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: Icon(
                            PhosphorIcons.phone(),
                            color: Colors.green,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.green.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          tooltip: 'Call Restaurant',
                        ),
                      ],
                    ),

                    // Cuisine type chips
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          cuisineTypes
                              .map(
                                (type) => Chip(
                                  label: Text(type),
                                  backgroundColor: Colors.green.withOpacity(
                                    0.1,
                                  ),
                                  side: BorderSide(
                                    color: Colors.green.shade200,
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.green.shade700,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              )
                              .toList(),
                    ),

                    const SizedBox(height: 16),

                    // Restaurant description (mock data)
                    Text(
                      'Welcome to ${restaurant.name}, a restaurant specializing in authentic local cuisine with international influences. We source fresh ingredients daily to bring you the best dining experience.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Other meals served here section
                    const Row(
                      children: [
                        Icon(Icons.restaurant_menu, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'MEALS SERVED HERE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              // Horizontal list of other meals
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: otherMeals.length,
                  itemBuilder: (context, index) {
                    final meal = otherMeals[index];
                    return Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 12),
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
                          // Meal image
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.network(
                              meal.imageUrl,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Meal name
                                Text(
                                  meal.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                // Meal calories and difficulty
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.local_fire_department,
                                          size: 14,
                                          color: Colors.orange.shade700,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${meal.calories}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        meal.difficulty,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Map section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.map, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'LOCATION & DIRECTIONS',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Map placeholder with overlay button
                    Stack(
                      children: [
                        // Map container
                        Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text('Map will be displayed here'),
                          ),
                        ),

                        // Get directions button overlay
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Opening directions...'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.directions),
                            label: const Text('Get Directions'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue.shade700,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Address text
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 18,
                            color: Colors.red.shade700,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              restaurant.address ?? 'Sinza , Dar es Salaam',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
