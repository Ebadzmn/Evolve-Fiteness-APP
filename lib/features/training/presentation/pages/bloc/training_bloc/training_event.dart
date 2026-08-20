import 'package:equatable/equatable.dart';

abstract class TrainingEvent extends Equatable {
  const TrainingEvent();
  @override
  List<Object?> get props => [];
}

class TrainingInitRequested extends TrainingEvent {
  const TrainingInitRequested();
}

class RefreshRequested extends TrainingEvent {
  const RefreshRequested();
}
