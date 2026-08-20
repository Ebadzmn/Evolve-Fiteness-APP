import 'package:equatable/equatable.dart';

abstract class TrainingHistoryEvent extends Equatable {
  const TrainingHistoryEvent();

  @override
  List<Object?> get props => [];
}

class TrainingHistoryLoadRequested extends TrainingHistoryEvent {
  const TrainingHistoryLoadRequested();
}
