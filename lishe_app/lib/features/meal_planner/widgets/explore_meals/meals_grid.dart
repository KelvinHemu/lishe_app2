import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/explore_meals_provider.dart';
import 'meal_card.dart';

class MealsGrid extends ConsumerStatefulWidget {
  const MealsGrid({super.key});

  @override
  ConsumerState<MealsGrid> createState() => _MealsGridState();
}

class _MealsGridState extends ConsumerState<MealsGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = ref.read(exploreMealsControllerProvider);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !state.isLoading &&
        state.hasMoreMeals) {
      ref.read(exploreMealsControllerProvider.notifier).loadMoreMeals();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(exploreMealsControllerProvider);

    if (state.meals.isEmpty) {
      if (state.isLoading) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return const Center(child: Text('No meals found in this category'));
      }
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      cacheExtent: 500,
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount:
          state.hasMoreMeals ? state.meals.length + 1 : state.meals.length,
      itemBuilder: (context, index) {
        if (index == state.meals.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        return MealCard(meal: state.meals[index]);
      },
    );
  }
}
