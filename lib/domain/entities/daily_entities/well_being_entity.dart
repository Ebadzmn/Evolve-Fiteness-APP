import 'package:equatable/equatable.dart';

class WellBeingEntity extends Equatable {
  final double energy;
  final double stress;
  final double muscleSoreness;
  final double mood;
  final double motivation;

  const WellBeingEntity({
    required this.energy,
    required this.stress,
    required this.muscleSoreness,
    required this.mood,
    required this.motivation,
  });

  WellBeingEntity copyWith({
    double? energy,
    double? stress,
    double? muscleSoreness,
    double? mood,
    double? motivation,
  }) => WellBeingEntity(
    energy: energy ?? this.energy,
    stress: stress ?? this.stress,
    muscleSoreness: muscleSoreness ?? this.muscleSoreness,
    mood: mood ?? this.mood,
    motivation: motivation ?? this.motivation,
  );

  @override
  List<Object?> get props => [energy, stress, muscleSoreness, mood, motivation];
}
