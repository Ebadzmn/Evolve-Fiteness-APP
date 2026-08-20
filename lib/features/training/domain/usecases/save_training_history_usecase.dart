import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/domain/repositories/training_history/training_plan_repository.dart';
import 'package:fitness_app/features/training/data/models/training_history_request_model.dart';

class SaveTrainingHistoryUseCase {
  final TrainingPlanRepository repository;

  SaveTrainingHistoryUseCase(this.repository);

  Future<Either<ApiException, void>> call(
    TrainingHistoryRequest request,
  ) async {
    return await repository.saveTrainingHistory(request);
  }
}
