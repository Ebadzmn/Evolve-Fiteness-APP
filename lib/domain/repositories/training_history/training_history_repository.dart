import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/domain/entities/training_entities/training_history_entity.dart';

abstract class TrainingHistoryRepository {
  Future<Either<ApiException, TrainingHistoryResponseEntity>> getHistory();
}
