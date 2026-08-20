import 'package:dartz/dartz.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../domain/entities/training_entities/exercise_entity.dart';
import '../../domain/repositories/exercise_repository.dart';

class GetExercisesUseCase {
  final ExerciseRepository repo;
  GetExercisesUseCase(this.repo);
  Future<Either<ApiException, List<ExerciseEntity>>> call({
    String? muscleCategory,
    int? page,
    int? limit,
    String? searchTerm,
  }) => repo.getExercises(
        muscleCategory: muscleCategory,
        page: page,
        limit: limit,
        searchTerm: searchTerm,
      );
}
