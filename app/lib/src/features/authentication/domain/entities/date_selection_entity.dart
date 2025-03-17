import 'package:equatable/equatable.dart';

class DateSelectionEntity extends Equatable {
  final DateTime selectedDate;

  const DateSelectionEntity({required this.selectedDate});

  @override
  List<Object?> get props => [selectedDate];
}
