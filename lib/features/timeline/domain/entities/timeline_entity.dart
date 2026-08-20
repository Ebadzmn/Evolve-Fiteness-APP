import 'package:equatable/equatable.dart';

class TimelineEntity extends Equatable {
  final String date;
  final String phase;

  const TimelineEntity({
    required this.date,
    required this.phase,
  });

  @override
  List<Object?> get props => [date, phase];
}
