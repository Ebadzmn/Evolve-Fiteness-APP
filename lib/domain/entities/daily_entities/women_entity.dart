import 'package:equatable/equatable.dart';

class WomenEntity extends Equatable {
  final String? cyclePhase; // e.g., Follicular, Luteal
  final String cycleDayLabel; // e.g., "Monday"
  final double pms;
  final double cramps;
  final Set<String> symptoms;

  const WomenEntity({
    required this.cyclePhase,
    required this.cycleDayLabel,
    required this.pms,
    required this.cramps,
    required this.symptoms,
  });

  WomenEntity copyWith({
    String? cyclePhase,
    String? cycleDayLabel,
    double? pms,
    double? cramps,
    Set<String>? symptoms,
  }) => WomenEntity(
    cyclePhase: cyclePhase ?? this.cyclePhase,
    cycleDayLabel: cycleDayLabel ?? this.cycleDayLabel,
    pms: pms ?? this.pms,
    cramps: cramps ?? this.cramps,
    symptoms: symptoms ?? this.symptoms,
  );

  @override
  List<Object?> get props => [cyclePhase, cycleDayLabel, pms, cramps, symptoms];
}
