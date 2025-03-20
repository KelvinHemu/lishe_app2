class NutritionItem {
  final String name;
  final double value;
  final String unit;

  const NutritionItem({
    required this.name,
    required this.value,
    required this.unit,
  });
}

class NutritionCategory {
  final String title;
  final String unit;
  final List<NutritionItem> items;

  const NutritionCategory({
    required this.title,
    required this.unit,
    required this.items,
  });
}
