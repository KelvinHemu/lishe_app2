import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/widgets/top_app_bar.dart';
import '../providers/explore_meals_provider.dart';
import '../widgets/explore_meals/category_filter.dart';
import '../widgets/explore_meals/meals_grid.dart';
import 'add_meal_screen.dart';

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
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  // Make animation controller nullable and initialize in initState
  AnimationController? _animationController;
  Animation<double>? _scaleAnimation;
  Animation<double>? _rotateAnimation;
  bool _animationsInitialized = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    // Initialize animations in a safe way
    _initializeAnimations();

    // Load meals after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(exploreMealsControllerProvider.notifier).loadInitialMeals();
    });
  }

  // Safely initialize animations
  void _initializeAnimations() {
    try {
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );

      _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
        CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
      );

      _rotateAnimation = Tween<double>(begin: 0, end: 0.1).animate(
        CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
      );

      _animationsInitialized = true;
    } catch (e) {
      debugPrint('Error initializing animations: $e');
      _animationsInitialized = false;
    }
  }

  @override
  void dispose() {
    // Safely dispose animation controller
    _animationController?.dispose();
    super.dispose();
  }

  // Safely animate the button on tap
  void _animateButton() {
    if (_animationsInitialized && _animationController != null) {
      _animationController!.forward().then((_) {
        _animationController!.reverse();
      });
    }
  }

  void _showAddMealSheet(BuildContext context) {
    _animateButton();

    // Navigate to the dedicated AddMealScreen instead of showing a bottom sheet
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AddMealScreen()));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Watch the provider with ref
    final controller = ref.watch(exploreMealsControllerProvider);

    return Scaffold(
      appBar: CustomAppBar(title: 'Explore Meals', showBackButton: true),
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            child: Column(
              children: [
                // Category filter section
                const CategoryFilter(),

                // Container for meals grid with fixed height
                SizedBox(
                  height: MediaQuery.of(context).size.height - 240,
                  child:
                      controller.isLoading && controller.meals.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : const MealsGrid(),
                ),
              ],
            ),
          ),

          // Floating Add Meal button with animation - with null safety checks
          Positioned(
            bottom: 20,
            right: 20,
            child:
                _animationsInitialized
                    ? AnimatedBuilder(
                      animation: _animationController!,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation!.value,
                          child: Transform.rotate(
                            angle: _rotateAnimation!.value,
                            child: SizedBox(
                              height: 65, // Increased size
                              width: 65, // Increased size
                              child: FloatingActionButton(
                                onPressed: () => _showAddMealSheet(context),
                                backgroundColor: Theme.of(context).primaryColor,
                                elevation: 6, // Increased elevation
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 32, // Increased size
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                    : FloatingActionButton(
                      // Fallback if animations aren't initialized
                      onPressed: () => _showAddMealSheet(context),
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
