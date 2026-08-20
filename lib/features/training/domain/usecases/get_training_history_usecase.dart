import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/domain/entities/training_entities/training_history_entity.dart';
import 'package:fitness_app/domain/repositories/training_history/training_history_repository.dart';

class GetTrainingHistoryUseCase {
  final TrainingHistoryRepository repository;

  GetTrainingHistoryUseCase(this.repository);

  Future<Either<ApiException, TrainingHistoryResponseEntity>> call() {
    return repository.getHistory();
  }
}
