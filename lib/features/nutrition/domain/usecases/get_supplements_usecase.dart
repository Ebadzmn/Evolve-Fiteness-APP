import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/supplement_entity.dart';
import 'package:fitness_app/features/nutrition/data/repositories/nutrition_repository.dart';

class GetSupplementsUseCase {
  final NutritionRepository repo;

  GetSupplementsUseCase(this.repo);

  Future<Either<ApiException, SupplementResponseEntity>> call(String userId) =>
      repo.getSupplements(userId);
}
