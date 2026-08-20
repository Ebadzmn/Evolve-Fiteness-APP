import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import '../../data/repositories/nutrition_repository.dart';

class UpdateWaterUseCase {
  final NutritionRepository repository;

  UpdateWaterUseCase(this.repository);

  Future<Either<ApiException, void>> call(DateTime date, String unit, int amount) {
    return repository.updateWater(date, unit, amount);
  }
}
