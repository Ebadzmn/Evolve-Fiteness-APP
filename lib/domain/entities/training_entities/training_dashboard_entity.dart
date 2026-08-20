import 'package:equatable/equatable.dart';

class TrainingDashboardEntity extends Equatable {
  final int prsThisWeek;
  final int weeklyVolumeKg;
  final int trainingsCount;

  const TrainingDashboardEntity({
    this.prsThisWeek = 0,
    this.weeklyVolumeKg = 0,
    this.trainingsCount = 0,
  });

  TrainingDashboardEntity copyWith({
    int? prsThisWeek,
    int? weeklyVolumeKg,
    int? trainingsCount,
  }) => TrainingDashboardEntity(
    prsThisWeek: prsThisWeek ?? this.prsThisWeek,
    weeklyVolumeKg: weeklyVolumeKg ?? this.weeklyVolumeKg,
    trainingsCount: trainingsCount ?? this.trainingsCount,
  );

  @override
  List<Object?> get props => [prsThisWeek, weeklyVolumeKg, trainingsCount];
}
