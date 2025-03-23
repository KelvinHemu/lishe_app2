import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../models/restaurant.dart';
import '../../models/meal.dart';

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

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Restaurant image header without text
          SliverAppBar(
            expandedHeight: 220.0,
            floating: false,
            pinned: true,
            // Remove the title from the FlexibleSpaceBar
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
                    // Restaurant name below the image - added this
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
                      ],
                    ),

                    const SizedBox(height: 24),

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
                    const Text(
                      'MEALS SERVED HERE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Meal image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              meal.imageUrl,
                              height: 120,
                              width: 160,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
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
                            children: [
                              Icon(
                                Icons.local_fire_department,
                                size: 14,
                                color: Colors.orange.shade700,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${meal.calories} kcal',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                meal.difficulty,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
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
                    const Text(
                      'LOCATION & DIRECTIONS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Map placeholder
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('Map will be displayed here'),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Address text
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 18,
                          color: Colors.red.shade700,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            restaurant.address ??
                                '123 Main Street, Nairobi, Kenya',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Directions button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Opening directions in Maps app'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: Icon(PhosphorIcons.navigationArrow()),
                        label: const Text('GET DIRECTIONS'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Call button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Calling restaurant'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: Icon(PhosphorIcons.phone()),
                        label: const Text('CALL RESTAURANT'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
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
