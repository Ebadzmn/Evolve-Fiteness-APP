import 'package:equatable/equatable.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_dashboard_entity.dart';

enum NutritionStatus { initial, loading, success, failure }

class NutritionState extends Equatable {
  final NutritionStatus status;
  final NutritionDashboardEntity? data;
  final String? errorMessage;

  const NutritionState({
    this.status = NutritionStatus.initial,
    this.data,
    this.errorMessage,
  });

  NutritionState copyWith({
    NutritionStatus? status,
    NutritionDashboardEntity? data,
    String? errorMessage,
  }) => NutritionState(
    status: status ?? this.status,
    data: data ?? this.data,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [status, data, errorMessage];
}
