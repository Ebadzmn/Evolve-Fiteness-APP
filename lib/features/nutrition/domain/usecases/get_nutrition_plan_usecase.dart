import 'package:dartz/dartz.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../domain/entities/nutrition_entities/nutrition_response_entity.dart';
import '../../data/repositories/nutrition_repository.dart';

class GetNutritionPlanUseCase {
  final NutritionRepository repository;

  GetNutritionPlanUseCase(this.repository);

  Future<Either<ApiException, NutritionPlanResponseEntity>> call(
    String userId,
  ) {
    return repository.getNutritionPlan(userId);
  }
}
