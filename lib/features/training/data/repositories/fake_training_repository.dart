import 'dart:async';
import '../../../../domain/entities/training_entities/training_dashboard_entity.dart';
import '../../../../domain/entities/training_entities/training_split_entity.dart';

class FakeTrainingRepository {
  Future<TrainingDashboardEntity> loadInitial() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return const TrainingDashboardEntity(
      prsThisWeek: 12,
      weeklyVolumeKg: 4850,
      trainingsCount: 5,
    );
  }

  Future<List<TrainingSplitItem>> loadTrainingSplit() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return const [
      TrainingSplitItem(dayLabel: 'Day 1', work: 'Chest'),
      TrainingSplitItem(dayLabel: 'Day 2', work: 'Back'),
      TrainingSplitItem(dayLabel: 'Day 3', work: 'Rest'),
      TrainingSplitItem(dayLabel: 'Day 4', work: 'Legs'),
      TrainingSplitItem(dayLabel: 'Day 5', work: 'Arms'),
      TrainingSplitItem(dayLabel: 'Day 6', work: 'Rest'),
      TrainingSplitItem(dayLabel: 'Day 7', work: 'Push'),
      TrainingSplitItem(dayLabel: 'Day 8', work: 'Pull'),
      TrainingSplitItem(dayLabel: 'Day 9', work: 'Rest'),
      TrainingSplitItem(dayLabel: 'Day 7', work: 'Push'),
      TrainingSplitItem(dayLabel: 'Day 8', work: 'Pull'),
      TrainingSplitItem(dayLabel: 'Day 9', work: 'Rest'),
    ];
  }
}
