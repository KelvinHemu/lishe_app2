import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/explore_meals_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/top_app_bar.dart';
import '../../models/app_bar_model.dart';
import '../widgets/explore_meals/category_filter.dart';
import '../widgets/explore_meals/meals_grid.dart';

class ExploreMealsPage extends ConsumerWidget {
  const ExploreMealsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ExploreMealsContent();
  }
}

class _ExploreMealsContent extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ExploreMealsContent> createState() =>
      _ExploreMealsContentState();
}

class _ExploreMealsContentState extends ConsumerState<_ExploreMealsContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Load meals after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fix the typo: change "exploreMealsControlleirProvider" to "exploreMealsControllerProvider"
      ref.read(exploreMealsControllerProvider.notifier).loadInitialMeals();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Watch the provider with ref
    final controller = ref.watch(exploreMealsControllerProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Explore Meals',
        showBackButton: true,
        actions: [
          AppBarItem(
            icon: Icons.tune,
            label: 'Filter',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filters coming soon!')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter chips
          const CategoryFilter(),

          // Grid of meals with pagination
          Expanded(
            child:
                controller.isLoading && controller.meals.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : const MealsGrid(),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
