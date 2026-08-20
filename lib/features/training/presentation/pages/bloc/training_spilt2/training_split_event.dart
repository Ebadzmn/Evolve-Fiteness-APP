import 'package:equatable/equatable.dart';

abstract class TrainingSplitEvent extends Equatable {
  const TrainingSplitEvent();
  @override
  List<Object?> get props => [];
}

class TrainingSplitInitRequested extends TrainingSplitEvent {
  const TrainingSplitInitRequested();
}
