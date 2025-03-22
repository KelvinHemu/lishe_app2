import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/explore_meals_provider.dart';

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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length + 1, // +1 for "All" option
        itemBuilder: (context, index) {
          // First item is "All" category
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
                // If "All" is selected, clear the category filter
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
      ),
    );
  }
}
