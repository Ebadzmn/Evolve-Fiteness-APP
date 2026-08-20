import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/domain/entities/training_entities/training_split_entity.dart';

abstract class TrainingSplitRepository {
  Future<Either<ApiException, List<TrainingSplitItem>>> getSplit(String userId);
}
