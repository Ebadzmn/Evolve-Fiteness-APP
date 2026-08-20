import 'package:equatable/equatable.dart';

class WorkoutTimerState extends Equatable {
  final int duration; // in seconds
  final bool isRunning;

  const WorkoutTimerState({this.duration = 0, this.isRunning = false});

  WorkoutTimerState copyWith({int? duration, bool? isRunning}) {
    return WorkoutTimerState(
      duration: duration ?? this.duration,
      isRunning: isRunning ?? this.isRunning,
    );
  }

  @override
  List<Object> get props => [duration, isRunning];
}
