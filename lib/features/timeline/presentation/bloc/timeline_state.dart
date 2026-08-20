import 'package:equatable/equatable.dart';
import '../../domain/entities/timeline_entity.dart';

abstract class TimelineState extends Equatable {
  const TimelineState();

  @override
  List<Object?> get props => [];
}

class TimelineInitial extends TimelineState {}

class TimelineLoading extends TimelineState {}

class TimelineLoaded extends TimelineState {
  final List<TimelineEntity> timelineData;

  const TimelineLoaded(this.timelineData);

  @override
  List<Object?> get props => [timelineData];
}

class TimelineEmpty extends TimelineState {}

class TimelineError extends TimelineState {
  final String message;

  const TimelineError(this.message);

  @override
  List<Object?> get props => [message];
}
