import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';
import 'package:fitness_app/domain/repositories/training_history/training_plan_repository.dart';

class GetTrainingPlansUseCase {
  final TrainingPlanRepository repository;

  GetTrainingPlansUseCase(this.repository);

  Future<Either<ApiException, List<TrainingPlanEntity>>> call() {
    return repository.getTrainingPlans();
  }
}
