import 'package:equatable/equatable.dart';

abstract class NutritionEvent extends Equatable {
  const NutritionEvent();
  @override
  List<Object?> get props => [];
}

class NutritionInitRequested extends NutritionEvent {
  const NutritionInitRequested();
}
