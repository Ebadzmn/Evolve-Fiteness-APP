import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';
import 'package:fitness_app/features/training/data/models/training_history_request_model.dart';

abstract class TrainingPlanRepository {
  Future<Either<ApiException, List<TrainingPlanEntity>>> getTrainingPlans();
  Future<Either<ApiException, TrainingPlanEntity>> getTrainingPlanById(
    String id,
  );
  Future<Either<ApiException, void>> saveTrainingHistory(
    TrainingHistoryRequest request,
  );
}
