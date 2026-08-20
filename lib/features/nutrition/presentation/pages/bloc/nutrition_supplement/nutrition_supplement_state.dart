import 'package:equatable/equatable.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/supplement_entity.dart';

enum NutritionSupplementStatus { initial, loading, success, failure }

class NutritionSupplementState extends Equatable {
  final NutritionSupplementStatus status;
  final SupplementResponseEntity? data;
  final String? errorMessage;

  const NutritionSupplementState({
    this.status = NutritionSupplementStatus.initial,
    this.data,
    this.errorMessage,
  });

  NutritionSupplementState copyWith({
    NutritionSupplementStatus? status,
    SupplementResponseEntity? data,
    String? errorMessage,
  }) {
    return NutritionSupplementState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, data, errorMessage];
}
