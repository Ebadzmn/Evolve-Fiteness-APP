import 'package:equatable/equatable.dart';

abstract class NutritionSupplementEvent extends Equatable {
  const NutritionSupplementEvent();

  @override
  List<Object?> get props => [];
}

class NutritionSupplementLoadRequested extends NutritionSupplementEvent {
  const NutritionSupplementLoadRequested();
}
