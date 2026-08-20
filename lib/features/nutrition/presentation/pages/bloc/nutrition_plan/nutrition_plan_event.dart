import 'package:equatable/equatable.dart';

abstract class NutritionPlanEvent extends Equatable {
  const NutritionPlanEvent();
  @override
  List<Object?> get props => [];
}

class NutritionPlanLoadRequested extends NutritionPlanEvent {
  const NutritionPlanLoadRequested();
}

class NutritionPlanTabChanged extends NutritionPlanEvent {
  final int index;
  const NutritionPlanTabChanged(this.index);
  @override
  List<Object> get props => [index];
}
