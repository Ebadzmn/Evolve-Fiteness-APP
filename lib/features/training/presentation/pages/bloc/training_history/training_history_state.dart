import 'package:equatable/equatable.dart';
import 'package:fitness_app/domain/entities/training_entities/training_history_entity.dart';

enum TrainingHistoryStatus { initial, loading, success, failure }

class TrainingHistoryState extends Equatable {
  final TrainingHistoryStatus status;
  final List<TrainingHistoryEntity> history;
  final String? errorMessage;

  const TrainingHistoryState({
    this.status = TrainingHistoryStatus.initial,
    this.history = const [],
    this.errorMessage,
  });

  TrainingHistoryState copyWith({
    TrainingHistoryStatus? status,
    List<TrainingHistoryEntity>? history,
    String? errorMessage,
  }) {
    return TrainingHistoryState(
      status: status ?? this.status,
      history: history ?? this.history,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, history, errorMessage];
}
