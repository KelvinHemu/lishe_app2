class NutritionData {
  final double proteinPercentage;
  final double carbsPercentage;
  final double fatsPercentage;
  final double fiberPercentage;
  final double vitaminsPercentage;

  const NutritionData({
    required this.proteinPercentage,
    required this.carbsPercentage,
    required this.fatsPercentage,
    required this.fiberPercentage,
    required this.vitaminsPercentage,
  });

  List<double> toList() => [
    proteinPercentage,
    carbsPercentage,
    fatsPercentage,
    fiberPercentage,
    vitaminsPercentage
  ];
}