import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import '../../../../domain/entities/training_entities/training_split_entity.dart';
import '../../../../domain/repositories/training_history/training_split_repository.dart';
import '../datasources/training_split_remote_data_source.dart';

class TrainingSplitRepositoryImpl implements TrainingSplitRepository {
  final TrainingSplitRemoteDataSource remoteDataSource;

  TrainingSplitRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ApiException, List<TrainingSplitItem>>> getSplit(
    String userId,
  ) async {
    try {
      final models = await remoteDataSource.fetchTrainingSplit(userId);
      return Right(models);
    } on ApiException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }
}
