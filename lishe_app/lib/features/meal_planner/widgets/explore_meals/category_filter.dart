import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lishe_app/features/meal_planner/controllers/explore_meals_controller.dart';
import '../../providers/explore_meals_provider.dart';

final categoriesProvider = Provider<List<String>>((ref) {
  final meals = ref.watch(exploreMealsControllerProvider).meals;
  final categories =
      meals
          .map((meal) => meal.category ?? '')
          .where((category) => category.isNotEmpty)
          .toSet()
          .toList();

  categories.sort();
  return categories;
});

class CategoryFilter extends ConsumerWidget {
  const CategoryFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exploreMealsControllerProvider);
    final categories = ref.watch(categoriesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search meals...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            onChanged: (value) {
              ref
                  .read(exploreMealsControllerProvider.notifier)
                  .updateSearchQuery(value);
            },
          ),
        ),

        // Filter tabs
        DefaultTabController(
          length: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16),
                child: const TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  tabs: [
                    Tab(text: 'Categories'),
                    Tab(text: 'Diet Type'),
                    Tab(text: 'Meal Type'),
                  ],
                  labelColor: Colors.green,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.green,
                ),
              ),

              SizedBox(
                height: 60,
                child: TabBarView(
                  children: [
                    // Categories filter
                    _buildCategoryFilters(ref, state, categories),

                    // Diet type filters
                    _buildDietTypeFilters(ref, state),

                    // Meal type filters
                    _buildMealTypeFilters(ref, state),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Active filters display
        if (state.hasAnyActiveFilters)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Display active category filter
                if (state.selectedCategory.isNotEmpty)
                  _buildActiveFilterChip(
                    label: state.selectedCategory,
                    onRemove: () {
                      ref
                          .read(exploreMealsControllerProvider.notifier)
                          .updateSelectedCategory('');
                    },
                  ),

                // Display active diet type filter
                if (state.selectedDietType.isNotEmpty &&
                    state.selectedDietType != 'Any')
                  _buildActiveFilterChip(
                    label: state.selectedDietType,
                    onRemove: () {
                      ref
                          .read(exploreMealsControllerProvider.notifier)
                          .updateDietType('Any');
                    },
                  ),

                // Display active meal type filters
                ...state.selectedMealTypes.map(
                  (type) => _buildActiveFilterChip(
                    label: type,
                    onRemove: () {
                      ref
                          .read(exploreMealsControllerProvider.notifier)
                          .toggleMealType(type);
                    },
                  ),
                ),

                // Clear all button if there are active filters
                if (state.hasAnyActiveFilters)
                  OutlinedButton.icon(
                    icon: const Icon(Icons.clear_all, size: 16),
                    label: const Text('Clear all'),
                    onPressed: () {
                      ref
                          .read(exploreMealsControllerProvider.notifier)
                          .resetFilters();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  // Category filters horizontal list
  Widget _buildCategoryFilters(
    WidgetRef ref,
    ExploreMealsState state,
    List<String> categories,
  ) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: categories.length + 1, // +1 for "All" option
      itemBuilder: (context, index) {
        final category = index == 0 ? "All" : categories[index - 1];
        final isSelected =
            index == 0
                ? state.selectedCategory.isEmpty
                : state.selectedCategory == category;

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            selected: isSelected,
            label: Text(category),
            onSelected: (_) {
              final selectedCategory = index == 0 ? "" : category;
              ref
                  .read(exploreMealsControllerProvider.notifier)
                  .updateSelectedCategory(selectedCategory);
            },
            backgroundColor: Colors.white,
            selectedColor: Colors.green,
            checkmarkColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      },
    );
  }

  // Diet type filters
  Widget _buildDietTypeFilters(WidgetRef ref, ExploreMealsState state) {
    final dietTypes = [
      'Any',
      'Vegetarian',
      'High Protein',
      'Low Carb',
      'Low Calorie',
    ];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: dietTypes.length,
      itemBuilder: (context, index) {
        final dietType = dietTypes[index];
        final isSelected = state.selectedDietType == dietType;

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            selected: isSelected,
            label: Text(dietType),
            onSelected: (_) {
              ref
                  .read(exploreMealsControllerProvider.notifier)
                  .updateDietType(dietType);
            },
            backgroundColor: Colors.white,
            selectedColor: Colors.green,
            checkmarkColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      },
    );
  }

  // Meal type filters
  Widget _buildMealTypeFilters(WidgetRef ref, ExploreMealsState state) {
    final mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: mealTypes.length,
      itemBuilder: (context, index) {
        final mealType = mealTypes[index];
        final isSelected = state.selectedMealTypes.contains(
          mealType.toLowerCase(),
        );

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            selected: isSelected,
            label: Text(mealType),
            onSelected: (_) {
              ref
                  .read(exploreMealsControllerProvider.notifier)
                  .toggleMealType(mealType.toLowerCase());
            },
            backgroundColor: Colors.white,
            selectedColor: Colors.green,
            checkmarkColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      },
    );
  }

  // Active filter chip with remove button
  Widget _buildActiveFilterChip({
    required String label,
    required VoidCallback onRemove,
  }) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: onRemove,
      backgroundColor: Colors.green.shade100,
      labelStyle: TextStyle(color: Colors.green.shade800),
    );
  }
}
