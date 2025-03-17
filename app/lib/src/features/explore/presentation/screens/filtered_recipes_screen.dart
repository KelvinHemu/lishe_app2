import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lishe_app2/src/features/explore/widgets/recommended_card.dart';

class FilteredRecipesScreen extends StatelessWidget {
  final Map<String, dynamic> filters;

  const FilteredRecipesScreen({
    super.key,
    required this.filters,
  });

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
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          title: const Text(
            'Filtered Recipes',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Active Filters Section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (filters['mealType'] != 'All')
                      Chip(
                        label: Text(filters['mealType']),
                        backgroundColor: Colors.blue[100],
                        labelStyle: TextStyle(color: Colors.blue[700]),
                      ),
                    if (filters['cuisine'] != 'All')
                      Chip(
                        label: Text(filters['cuisine']),
                        backgroundColor: Colors.blue[100],
                        labelStyle: TextStyle(color: Colors.blue[700]),
                      ),
                    ...?filters['dietaryPreferences']?.map<Widget>((pref) => Chip(
                      label: Text(pref),
                      backgroundColor: Colors.blue[100],
                      labelStyle: TextStyle(color: Colors.blue[700]),
                    )),
                    Chip(
                      label: Text('${filters['preparationTime'].start.round()}-${filters['preparationTime'].end.round()} min'),
                      backgroundColor: Colors.blue[100],
                      labelStyle: TextStyle(color: Colors.blue[700]),
                    ),
                  ],
                ),
              ),
              
              // Results Count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(
                  '15 recipes found',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Recipe Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.05,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  ),
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    // Sample recipe data
                    final recipes = [
                      {
                        'title': 'Healthy Breakfast Bowl',
                        'time': '20 min',
                        'rating': 4.5,
                        'ratingCount': 12,
                        'icon': Icons.breakfast_dining,
                      },
                      {
                        'title': 'Quinoa Buddha Bowl',
                        'time': '25 min',
                        'rating': 4.8,
                        'ratingCount': 15,
                        'icon': Icons.lunch_dining,
                      },
                      {
                        'title': 'Grilled Salmon Salad',
                        'time': '30 min',
                        'rating': 4.2,
                        'ratingCount': 8,
                        'icon': Icons.dinner_dining,
                      },
                      {
                        'title': 'Vegetarian Stir Fry',
                        'time': '25 min',
                        'rating': 4.6,
                        'ratingCount': 10,
                        'icon': Icons.restaurant,
                      },
                      {
                        'title': 'Mediterranean Pasta',
                        'time': '35 min',
                        'rating': 4.7,
                        'ratingCount': 18,
                        'icon': Icons.restaurant,
                      },
                    ][index % 5]; // Cycle through sample recipes

                    return RecommendedCard(
                      imageIcon: recipes['icon'] as IconData,
                      title: recipes['title'] as String,
                      time: recipes['time'] as String,
                      rating: recipes['rating'] as double,
                      ratingCount: recipes['ratingCount'] as int,
                      onTap: () {
                        // Handle recipe tap
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 