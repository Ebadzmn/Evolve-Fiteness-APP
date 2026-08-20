import 'package:dartz/dartz.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../domain/entities/training_entities/exercise_entity.dart';

abstract class ExerciseRepository {
  Future<Either<ApiException, List<ExerciseEntity>>> getExercises({
    String? muscleCategory,
    int? page,
    int? limit,
    String? searchTerm,
  });
  Future<Either<ApiException, ExerciseEntity>> getExerciseById(String id);
}
