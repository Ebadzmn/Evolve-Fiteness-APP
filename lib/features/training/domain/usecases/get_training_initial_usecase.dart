import 'package:fitness_app/domain/entities/training_entities/training_dashboard_entity.dart';

import '../../data/repositories/fake_training_repository.dart';

class GetTrainingInitialUseCase {
  final FakeTrainingRepository repo;
  GetTrainingInitialUseCase(this.repo);
  Future<TrainingDashboardEntity> call() => repo.loadInitial();
}
