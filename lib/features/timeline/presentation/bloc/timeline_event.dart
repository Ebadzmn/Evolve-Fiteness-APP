import 'package:equatable/equatable.dart';

abstract class TimelineEvent extends Equatable {
  const TimelineEvent();

  @override
  List<Object> get props => [];
}

class FetchTimeline extends TimelineEvent {
  final String athleteId;

  const FetchTimeline(this.athleteId);

  @override
  List<Object> get props => [athleteId];
}
