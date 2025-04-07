class Meal {
  final String name;
  final String image;
  final List<String> ingredients;
  final int calories;
  final int protein;
  final int fat;
  final int carbs;
  final int costTZS;
  final List<String> suitableFor; // ['weight gain', 'budget friendly']

  Meal({
    required this.name,
    required this.image,
    required this.ingredients,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.costTZS,
    required this.suitableFor,
  });

  factory Meal.fromLocalJson(Map<String, dynamic> json) => Meal(
    name: json['name'],
    image: json['image'] ?? '',
    ingredients: List<String>.from(json['ingredients'].map((i) => i['name'])),
    calories: json['calories'],
    protein: json['protein'],
    fat: json['fat'],
    carbs: json['carbs'],
    costTZS: json['estimated_cost_tzs'],
    suitableFor: List<String>.from(json['suitable_for']),
  );

  factory Meal.fromSpoonacularJson(Map<String, dynamic> json) => Meal(
    name: json['title'],
    image: json['image'],
    ingredients: [], // you can fetch details later
    calories: json['nutrition']?['nutrients']?[0]?['amount']?.toInt() ?? 0,
    protein: json['nutrition']?['nutrients']?[1]?['amount']?.toInt() ?? 0,
    fat: json['nutrition']?['nutrients']?[2]?['amount']?.toInt() ?? 0,
    carbs: json['nutrition']?['nutrients']?[3]?['amount']?.toInt() ?? 0,
    costTZS: 0, // optional: estimate using conversion
    suitableFor: [], // you can tag later using logic
  );
}
