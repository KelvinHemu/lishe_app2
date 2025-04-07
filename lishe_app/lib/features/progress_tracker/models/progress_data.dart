import 'progress_models.dart';

class ProgressData {
  final List<ProgressDataPoint> calorieData;
  final List<ProgressDataPoint> proteinData;
  final List<ProgressDataPoint> weightData;

  const ProgressData({
    required this.calorieData,
    required this.proteinData,
    required this.weightData, required DateTime date, required double value,
  });
}