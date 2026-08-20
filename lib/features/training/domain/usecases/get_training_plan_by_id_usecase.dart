import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';
import 'package:fitness_app/domain/repositories/training_history/training_plan_repository.dart';

class GetTrainingPlanByIdUseCase {
  final TrainingPlanRepository repository;

  GetTrainingPlanByIdUseCase({required this.repository});

  Future<Either<ApiException, TrainingPlanEntity>> call(String id) async {
    return await repository.getTrainingPlanById(id);
  }
}
