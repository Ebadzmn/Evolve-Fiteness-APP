import 'package:equatable/equatable.dart';
import 'package:fitness_app/domain/entities/training_entities/training_split_entity.dart';

enum TrainingSplitStatus { initial, loading, success, failure }

class TrainingSplitState extends Equatable {
  final TrainingSplitStatus status;
  final List<TrainingSplitItem> split;
  final String? errorMessage;

  const TrainingSplitState({
    this.status = TrainingSplitStatus.initial,
    this.split = const [],
    this.errorMessage,
  });

  TrainingSplitState copyWith({
    TrainingSplitStatus? status,
    List<TrainingSplitItem>? split,
    String? errorMessage,
  }) {
    return TrainingSplitState(
      status: status ?? this.status,
      split: split ?? this.split,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, split, errorMessage];
}
