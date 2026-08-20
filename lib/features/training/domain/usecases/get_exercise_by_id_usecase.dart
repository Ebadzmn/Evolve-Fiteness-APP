import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/domain/entities/training_entities/exercise_entity.dart';
import 'package:fitness_app/features/training/domain/repositories/exercise_repository.dart';

class GetExerciseByIdUseCase {
  final ExerciseRepository repository;

  GetExerciseByIdUseCase({required this.repository});

  Future<Either<ApiException, ExerciseEntity>> call(String id) {
    return repository.getExerciseById(id);
  }
}
