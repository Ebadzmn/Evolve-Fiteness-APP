import 'package:equatable/equatable.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_response_entity.dart';

enum NutritionPlanStatus { initial, loading, success, failure }

class NutritionPlanState extends Equatable {
  final NutritionPlanStatus status;
  final NutritionPlanEntity? data;
  final String? errorMessage;
  final NutritionPlanResponseEntity? fullData;
  final int selectedTabIndex;

  const NutritionPlanState({
    this.status = NutritionPlanStatus.initial,
    this.data,
    this.errorMessage,
    this.fullData,
    this.selectedTabIndex = 0,
  });

  NutritionPlanState copyWith({
    NutritionPlanStatus? status,
    NutritionPlanEntity? data,
    String? errorMessage,
    NutritionPlanResponseEntity? fullData,
    int? selectedTabIndex,
  }) {
    return NutritionPlanState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      fullData: fullData ?? this.fullData,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }

  @override
  List<Object?> get props => [
    status,
    data,
    errorMessage,
    fullData,
    selectedTabIndex,
  ];
}
