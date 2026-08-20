import 'package:equatable/equatable.dart';
import '../../../../../../domain/entities/training_entities/training_dashboard_entity.dart';

enum TrainingStatus { initial, loading, ready, error }

class TrainingState extends Equatable {
  final TrainingStatus status;
  final TrainingDashboardEntity? data;
  final String? errorMessage;

  const TrainingState({
    this.status = TrainingStatus.initial,
    this.data,
    this.errorMessage,
  });

  TrainingState copyWith({
    TrainingStatus? status,
    TrainingDashboardEntity? data,
    String? errorMessage,
  }) => TrainingState(
    status: status ?? this.status,
    data: data ?? this.data,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [status, data, errorMessage];
}
