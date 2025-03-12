import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lishe_app2/src/features/explore/presentation/screens/filter_screen.dart';
import 'package:lishe_app2/src/features/explore/widgets/recommended_card.dart';
import 'package:lishe_app2/src/features/explore/widgets/your_recipe_card.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarColor: Colors.white
          ),
        ),
        ),
      body: ListView(
        padding: const EdgeInsets.only(
          left: 24,
          right: 24,
          bottom: kBottomNavigationBarHeight + 20,
          top: 50,
        ),
        children: [
          // Tasty dish text
          Text(
            "Got a tasty dish in mind?",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          
          // Search Bar
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for healthy recipes, tips...',
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.grey[600]),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.tune, color: Colors.grey[600]),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FilterScreen()),
                        );
                        if (result != null) {
                          // Handle filter results
                          print(result);
                        }
                      },
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
      
          // Meal Type Cards
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Breakfast',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[500],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Lunch',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[500],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Dinner',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          
          // Content Container
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFBBDEFB),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AI Icon and Text Row
                Row(
                  children: [
                    Icon(
                      Icons.smart_toy_outlined,
                      color: Colors.blue[500],
                      size: 40,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Level Up your cooking experience with AI support',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Search Bar with Microphone
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[500]!.withOpacity(0.3)),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Ask here',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue[500],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.mic,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          
          // Recommended for you
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recommended for you',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See more',
                  style: TextStyle(
                    color: Colors.blue[500],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 190,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                RecommendedCard(
                  imageIcon: Icons.breakfast_dining,
                  title: 'Healthy Breakfast Bowl',
                  time: '20 min',
                  rating: 4.5,
                  ratingCount: 12,
                  onTap: () {},
                ),
                RecommendedCard(
                  imageIcon: Icons.lunch_dining,
                  title: 'Grilled Salmon Salad',
                  time: '25 min',
                  rating: 4.2,
                  ratingCount: 8,
                  onTap: () {},
                ),
                RecommendedCard(
                  imageIcon: Icons.dinner_dining,
                  title: 'Quinoa Buddha Bowl',
                  time: '30 min',
                  rating: 4.8,
                  ratingCount: 15,
                  onTap: () {},
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 4),
          
          // Your recipes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your recipes',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See all',
                  style: TextStyle(
                    color: Colors.blue[500],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                YourRecipeCard(
                  imageIcon: Icons.local_pizza,
                  title: 'Homemade Pizza',
                  time: '45 min',
                  onTap: () {},
                ),
                YourRecipeCard(
                  imageIcon: Icons.restaurant,
                  title: 'Chicken Stir Fry',
                  time: '30 min',
                  onTap: () {},
                ),
                YourRecipeCard(
                  imageIcon: Icons.dinner_dining,
                  title: 'Vegetable Pasta',
                  time: '25 min',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

