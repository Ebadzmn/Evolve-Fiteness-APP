import 'package:equatable/equatable.dart';

abstract class TrainingSplitEvent extends Equatable {
  const TrainingSplitEvent();

  @override
  List<Object> get props => [];
}

class TrainingSplitLoadRequested extends TrainingSplitEvent {
  const TrainingSplitLoadRequested();
}
