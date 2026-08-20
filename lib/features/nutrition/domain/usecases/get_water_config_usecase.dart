import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/features/nutrition/data/repositories/nutrition_repository.dart';

class GetWaterConfigUseCase {
  final NutritionRepository repo;

  GetWaterConfigUseCase(this.repo);

  Future<Either<ApiException, Map<String, int>>> call(DateTime date) {
    return repo.getWaterConfig(date);
  }
}
