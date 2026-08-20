import 'package:equatable/equatable.dart';

abstract class TrainingPlanEvent extends Equatable {
  const TrainingPlanEvent();

  @override
  List<Object?> get props => [];
}

class TrainingPlanLoadRequested extends TrainingPlanEvent {
  const TrainingPlanLoadRequested();
}

class TrainingPlanReordered extends TrainingPlanEvent {
  final int oldIndex;
  final int newIndex;

  const TrainingPlanReordered(this.oldIndex, this.newIndex);

  @override
  List<Object?> get props => [oldIndex, newIndex];
}
