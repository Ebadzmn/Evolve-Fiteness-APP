import 'package:equatable/equatable.dart';

abstract class NutritionStatisticsEvent extends Equatable {
  const NutritionStatisticsEvent();

  @override
  List<Object?> get props => [];
}

class NutritionStatisticsLoadRequested extends NutritionStatisticsEvent {
  final DateTime date;

  const NutritionStatisticsLoadRequested(this.date);

  @override
  List<Object?> get props => [date];
}
