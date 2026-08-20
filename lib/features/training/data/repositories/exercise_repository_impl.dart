import 'package:dartz/dartz.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../domain/entities/training_entities/exercise_entity.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../datasources/exercise_remote_data_source.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  final ExerciseRemoteDataSource remoteDataSource;

  ExerciseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ApiException, List<ExerciseEntity>>> getExercises({
    String? muscleCategory,
    int? page,
    int? limit,
    String? searchTerm,
  }) async {
    try {
      final models = await remoteDataSource.fetchExercises(
        muscleCategory: muscleCategory,
        page: page,
        limit: limit,
        searchTerm: searchTerm,
      );
      return Right(models);
    } on ApiException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  @override
  Future<Either<ApiException, ExerciseEntity>> getExerciseById(
    String id,
  ) async {
    try {
      final model = await remoteDataSource.fetchExerciseById(id);
      return Right(model);
    } on ApiException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }
}
