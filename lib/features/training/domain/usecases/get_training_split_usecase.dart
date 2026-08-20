import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/domain/entities/training_entities/training_split_entity.dart';
import 'package:fitness_app/domain/repositories/training_history/training_split_repository.dart';

class GetTrainingSplitUseCase {
  final TrainingSplitRepository repo;
  GetTrainingSplitUseCase(this.repo);

  Future<Either<ApiException, List<TrainingSplitItem>>> call(String userId) =>
      repo.getSplit(userId);
}
