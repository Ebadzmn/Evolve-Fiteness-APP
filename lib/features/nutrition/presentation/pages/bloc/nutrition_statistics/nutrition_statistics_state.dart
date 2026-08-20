import 'package:equatable/equatable.dart';
import '../../../../../../../domain/entities/nutrition_entities/nutrition_statistics_entity.dart';

enum NutritionStatisticsStatus { initial, loading, success, failure }

class NutritionStatisticsState extends Equatable {
  final NutritionStatisticsStatus status;
  final NutritionStatisticsEntity? statistics;
  final String? errorMessage;
  final DateTime date;

  const NutritionStatisticsState({
    this.status = NutritionStatisticsStatus.initial,
    this.statistics,
    this.errorMessage,
    required this.date,
  });

  NutritionStatisticsState copyWith({
    NutritionStatisticsStatus? status,
    NutritionStatisticsEntity? statistics,
    String? errorMessage,
    DateTime? date,
  }) {
    return NutritionStatisticsState(
      status: status ?? this.status,
      statistics: statistics ?? this.statistics,
      errorMessage: errorMessage ?? this.errorMessage,
      date: date ?? this.date,
    );
  }

  @override
  List<Object?> get props => [status, statistics, errorMessage, date];
}
