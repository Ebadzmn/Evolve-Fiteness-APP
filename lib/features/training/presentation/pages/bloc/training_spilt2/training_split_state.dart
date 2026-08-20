import 'package:equatable/equatable.dart';
import 'package:fitness_app/domain/entities/training_entities/training_split_entity.dart';

enum TrainingSplitStatus { initial, loading, ready, error }

class TrainingSplitState extends Equatable {
  final TrainingSplitStatus status;
  final List<TrainingSplitItem> items;
  final String? errorMessage;
  const TrainingSplitState({
    this.status = TrainingSplitStatus.initial,
    this.items = const [],
    this.errorMessage,
  });

  TrainingSplitState copyWith({
    TrainingSplitStatus? status,
    List<TrainingSplitItem>? items,
    String? errorMessage,
  }) => TrainingSplitState(
    status: status ?? this.status,
    items: items ?? this.items,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [status, items, errorMessage];
}
