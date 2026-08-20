import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/domain/entities/training_entities/training_history_entity.dart';
import 'package:fitness_app/domain/repositories/training_history/training_history_repository.dart';
import 'package:fitness_app/features/training/data/datasources/training_remote_datasource.dart';

class TrainingHistoryRepositoryImpl implements TrainingHistoryRepository {
  final TrainingRemoteDataSource remoteDataSource;

  TrainingHistoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ApiException, TrainingHistoryResponseEntity>>
  getHistory() async {
    try {
      final result = await remoteDataSource.getTrainingHistory();
      return Right(result);
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }
}
